<#
    Integration tests for ServiceDesk.Cloud.Requests.

    Prerequisites
    -------------
    The following must be present before running:

      SecretManagement vault secrets:
        ZohoSdpApiClientId      – OAuth2 client ID (plain text secret)
        ZohoSdpApiClientSecret  – OAuth2 client secret (SecureString secret)

      Environment variables:
        SDP_PORTAL_NAME         – Portal name from your SDP Cloud URL
                                  (e.g. 'itdesk' from .../app/itdesk)
        SDP_REGION              – Data-center region: US | EU | AU | IN | JP | CA
                                  Defaults to 'US' if not set.

    Run integration tests only:
        Invoke-Pester ./tests/Integration/ -Tag Integration

    Run everything except integration tests:
        Invoke-Pester ./tests/ -ExcludeTag Integration
#>

BeforeDiscovery {
    $script:Skip         = $false
    $script:SkipWorklogs = $false

    if (-not $env:SDP_PORTAL_NAME) {
        Write-Warning 'SDP_PORTAL_NAME environment variable is not set. Skipping integration tests.'
        $script:Skip = $true
        return
    }

    try {
        $id = Get-Secret ZohoSdpApiClientId -AsPlainText -ErrorAction Stop
        if (-not $id) { throw 'Empty secret' }
    } catch {
        Write-Warning 'ZohoSdpApiClientId secret not found in vault. Skipping integration tests.'
        $script:Skip = $true
        return
    }

    if (-not $env:SDP_WORKLOG_OWNER_ID) {
        Write-Warning 'SDP_WORKLOG_OWNER_ID environment variable is not set. Worklog tests will be skipped.'
        $script:SkipWorklogs = $true
    }
}

BeforeAll {
    if ($script:Skip) { return }

    Import-Module "$PSScriptRoot/../../ServiceDesk.Cloud.Requests/ServiceDesk.Cloud.Requests.psd1" -Force

    $region     = $env:SDP_REGION ?? 'US'
    $portalName = $env:SDP_PORTAL_NAME
    $clientId   = Get-Secret ZohoSdpApiClientId -AsPlainText
    $secret     = Get-Secret ZohoSdpApiClientSecret

    Connect-SDPService -Region $region -PortalName $portalName -ClientId $clientId -ClientSecret $secret

    $script:TestId      = (New-Guid).ToString('N').Substring(0, 8).ToUpper()
    $script:TestSubject = "[PESTER $($script:TestId)] Integration test request"

    $script:Request     = $null
    $script:Note        = $null
    $script:Task        = $null
    $script:Worklog     = $null
    $script:TaskWorklog = $null
}

AfterAll {
    if ($script:Skip) { return }

    # Safety-net cleanup in case individual Remove tests were skipped or failed.
    if ($script:Request) {
        Remove-SDPRequest -Id $script:Request.Id -Confirm:$false -ErrorAction SilentlyContinue
    }

    Disconnect-SDPService -ErrorAction SilentlyContinue
}

# ---------------------------------------------------------------------------
# Connection
# ---------------------------------------------------------------------------

Describe 'Connection' -Tag Integration {
    It 'Connect-SDPService establishes a session' -Skip:$script:Skip {
        { Connect-SDPService -Region ($env:SDP_REGION ?? 'US') `
                             -PortalName $env:SDP_PORTAL_NAME `
                             -ClientId (Get-Secret ZohoSdpApiClientId -AsPlainText) `
                             -ClientSecret (Get-Secret ZohoSdpApiClientSecret) } |
            Should -Not -Throw
    }

    It 'Get-SDPRequest returns at least one result' -Skip:$script:Skip {
        $results = Get-SDPRequest -PageSize 1
        $results | Should -Not -BeNullOrEmpty
    }
}

# ---------------------------------------------------------------------------
# Request CRUD
# ---------------------------------------------------------------------------

Describe 'Request' -Tag Integration {
    It 'New-SDPRequest creates a request and returns an SDPRequest' -Skip:$script:Skip {
        $script:Request = New-SDPRequest -Subject $script:TestSubject `
                                         -Description 'Created by Pester integration tests.' `
                                         -PriorityName 'Low'

        $script:Request           | Should -Not -BeNullOrEmpty
        $script:Request.Id        | Should -BeGreaterThan 0
        $script:Request.Subject   | Should -Be $script:TestSubject
        $script:Request.GetType().Name | Should -Be 'SDPRequest'
    }

    It 'Get-SDPRequest retrieves the created request by Id' -Skip:$script:Skip {
        if (-not $script:Request) { Set-ItResult -Skipped -Because 'request was not created' ; return }

        $fetched = Get-SDPRequest -Id $script:Request.Id
        $fetched.Id      | Should -Be $script:Request.Id
        $fetched.Subject | Should -Be $script:TestSubject
    }

    It 'Get-SDPRequest list includes the created request' -Skip:$script:Skip {
        if (-not $script:Request) { Set-ItResult -Skipped -Because 'request was not created' ; return }

        $list = Get-SDPRequest -Filter @(
            @{ field = 'subject'; condition = 'contains'; value = $script:TestId }
        )
        $list.Id | Should -Contain $script:Request.Id
    }

    It 'Set-SDPRequest updates the request and returns the updated object' -Skip:$script:Skip {
        if (-not $script:Request) { Set-ItResult -Skipped -Because 'request was not created' ; return }

        $updated = Set-SDPRequest -Id $script:Request.Id `
                                  -Description 'Updated by Pester integration tests.'

        $updated.Id | Should -Be $script:Request.Id
        $updated.GetType().Name | Should -Be 'SDPRequest'
    }

    It 'SDPRequest output object has expected properties' -Skip:$script:Skip {
        if (-not $script:Request) { Set-ItResult -Skipped -Because 'request was not created' ; return }

        $script:Request.PSObject.Properties.Name | Should -Contain 'Id'
        $script:Request.PSObject.Properties.Name | Should -Contain 'Subject'
        $script:Request.PSObject.Properties.Name | Should -Contain 'Status'
        $script:Request.PSObject.Properties.Name | Should -Contain 'Priority'
        $script:Request.PSObject.Properties.Name | Should -Contain 'Requester'
        $script:Request.PSObject.Properties.Name | Should -Contain 'CreatedTime'
        $script:Request.RawData                  | Should -Not -BeNullOrEmpty
    }

    It 'SDPReference fields expose Name as string' -Skip:$script:Skip {
        if (-not $script:Request) { Set-ItResult -Skipped -Because 'request was not created' ; return }

        $script:Request.Priority.GetType().Name | Should -Be 'SDPReference'
        $script:Request.Priority.Name           | Should -BeOfType [string]
    }

    It 'Pipeline: Get-SDPRequest | Set-SDPRequest works' -Skip:$script:Skip {
        if (-not $script:Request) { Set-ItResult -Skipped -Because 'request was not created' ; return }

        { Get-SDPRequest -Id $script:Request.Id | Set-SDPRequest -Description 'Pipeline update test.' } |
            Should -Not -Throw
    }
}

# ---------------------------------------------------------------------------
# Request Note CRUD
# ---------------------------------------------------------------------------

Describe 'RequestNote' -Tag Integration {
    It 'New-SDPRequestNote adds a note and returns an SDPRequestNote' -Skip:$script:Skip {
        if (-not $script:Request) { Set-ItResult -Skipped -Because 'request was not created' ; return }

        $script:Note = New-SDPRequestNote -RequestId $script:Request.Id `
                                          -Description 'Pester integration test note.' `
                                          -IsPublic $false

        $script:Note              | Should -Not -BeNullOrEmpty
        $script:Note.Id           | Should -BeGreaterThan 0
        $script:Note.RequestId    | Should -Be $script:Request.Id
        $script:Note.Description  | Should -Be 'Pester integration test note.'
        $script:Note.IsPublic     | Should -Be $false
        $script:Note.GetType().Name | Should -Be 'SDPRequestNote'
    }

    It 'Get-SDPRequestNote retrieves the note by Id' -Skip:$script:Skip {
        if (-not $script:Note) { Set-ItResult -Skipped -Because 'note was not created' ; return }

        $fetched = Get-SDPRequestNote -RequestId $script:Request.Id -Id $script:Note.Id
        $fetched.Id | Should -Be $script:Note.Id
    }

    It 'Get-SDPRequestNote list includes the created note' -Skip:$script:Skip {
        if (-not $script:Note) { Set-ItResult -Skipped -Because 'note was not created' ; return }

        $list = Get-SDPRequestNote -RequestId $script:Request.Id
        $list.Id | Should -Contain $script:Note.Id
    }

    It 'Set-SDPRequestNote updates the note' -Skip:$script:Skip {
        if (-not $script:Note) { Set-ItResult -Skipped -Because 'note was not created' ; return }

        $updated = Set-SDPRequestNote -RequestId $script:Request.Id `
                                      -Id $script:Note.Id `
                                      -Description 'Updated by Pester.'

        $updated.Id | Should -Be $script:Note.Id
        $updated.GetType().Name | Should -Be 'SDPRequestNote'
    }

    It 'Remove-SDPRequestNote deletes the note' -Skip:$script:Skip {
        if (-not $script:Note) { Set-ItResult -Skipped -Because 'note was not created' ; return }

        { Remove-SDPRequestNote -RequestId $script:Request.Id -Id $script:Note.Id -Confirm:$false } |
            Should -Not -Throw

        { Get-SDPRequestNote -RequestId $script:Request.Id -Id $script:Note.Id } |
            Should -Throw

        $script:Note = $null
    }
}

# ---------------------------------------------------------------------------
# Request Task CRUD
# ---------------------------------------------------------------------------

Describe 'RequestTask' -Tag Integration {
    It 'New-SDPRequestTask creates a task and returns an SDPRequestTask' -Skip:$script:Skip {
        if (-not $script:Request) { Set-ItResult -Skipped -Because 'request was not created' ; return }

        $script:Task = New-SDPRequestTask -RequestId $script:Request.Id `
                                          -Title 'Pester integration test task'

        $script:Task              | Should -Not -BeNullOrEmpty
        $script:Task.Id           | Should -BeGreaterThan 0
        $script:Task.RequestId    | Should -Be $script:Request.Id
        $script:Task.Title        | Should -Be 'Pester integration test task'
        $script:Task.GetType().Name | Should -Be 'SDPRequestTask'
    }

    It 'Get-SDPRequestTask retrieves the task by Id' -Skip:$script:Skip {
        if (-not $script:Task) { Set-ItResult -Skipped -Because 'task was not created' ; return }

        $fetched = Get-SDPRequestTask -RequestId $script:Request.Id -Id $script:Task.Id
        $fetched.Id    | Should -Be $script:Task.Id
        $fetched.Title | Should -Be 'Pester integration test task'
    }

    It 'Get-SDPRequestTask list includes the created task' -Skip:$script:Skip {
        if (-not $script:Task) { Set-ItResult -Skipped -Because 'task was not created' ; return }

        $list = Get-SDPRequestTask -RequestId $script:Request.Id
        $list.Id | Should -Contain $script:Task.Id
    }

    It 'Set-SDPRequestTask updates the task' -Skip:$script:Skip {
        if (-not $script:Task) { Set-ItResult -Skipped -Because 'task was not created' ; return }

        $updated = Set-SDPRequestTask -RequestId $script:Request.Id `
                                      -Id $script:Task.Id `
                                      -PercentageCompletion 50

        $updated.Id | Should -Be $script:Task.Id
        $updated.GetType().Name | Should -Be 'SDPRequestTask'
    }

    It 'Remove-SDPRequestTask deletes the task' -Skip:$script:Skip {
        if (-not $script:Task) { Set-ItResult -Skipped -Because 'task was not created' ; return }

        { Remove-SDPRequestTask -RequestId $script:Request.Id -Id $script:Task.Id -Confirm:$false } |
            Should -Not -Throw

        { Get-SDPRequestTask -RequestId $script:Request.Id -Id $script:Task.Id } |
            Should -Throw

        $script:Task = $null
    }
}

# ---------------------------------------------------------------------------
# Request Worklog CRUD
# ---------------------------------------------------------------------------

Describe 'RequestWorklog' -Tag Integration {
    It 'New-SDPRequestWorklog creates a worklog and returns an SDPRequestWorklog' -Skip:($script:Skip -or $script:SkipWorklogs) {
        if (-not $script:Request) { Set-ItResult -Skipped -Because 'request was not created' ; return }

        $endTime   = Get-Date
        $startTime = $endTime.AddMinutes(-30)
        $script:Worklog = New-SDPRequestWorklog -RequestId $script:Request.Id `
                                                -Description 'Pester integration test worklog.' `
                                                -OwnerId $env:SDP_WORKLOG_OWNER_ID `
                                                -StartTime $startTime `
                                                -EndTime $endTime

        $script:Worklog              | Should -Not -BeNullOrEmpty
        $script:Worklog.Id           | Should -BeGreaterThan 0
        $script:Worklog.RequestId    | Should -Be $script:Request.Id
        $script:Worklog.TimeSpent    | Should -BeGreaterThan 0
        $script:Worklog.GetType().Name | Should -Be 'SDPRequestWorklog'
    }

    It 'Get-SDPRequestWorklog retrieves the worklog by Id' -Skip:($script:Skip -or $script:SkipWorklogs) {
        if (-not $script:Worklog) { Set-ItResult -Skipped -Because 'worklog was not created' ; return }

        $fetched = Get-SDPRequestWorklog -RequestId $script:Request.Id -Id $script:Worklog.Id
        $fetched.Id | Should -Be $script:Worklog.Id
    }

    It 'Get-SDPRequestWorklog list includes the created worklog' -Skip:($script:Skip -or $script:SkipWorklogs) {
        if (-not $script:Worklog) { Set-ItResult -Skipped -Because 'worklog was not created' ; return }

        $list = Get-SDPRequestWorklog -RequestId $script:Request.Id
        $list.Id | Should -Contain $script:Worklog.Id
    }

    It 'Set-SDPRequestWorklog updates the worklog' -Skip:($script:Skip -or $script:SkipWorklogs) {
        if (-not $script:Worklog) { Set-ItResult -Skipped -Because 'worklog was not created' ; return }

        $updEnd   = Get-Date
        $updStart = $updEnd.AddMinutes(-45)
        $updated = Set-SDPRequestWorklog -RequestId $script:Request.Id `
                                         -Id $script:Worklog.Id `
                                         -Description 'Updated by Pester.' `
                                         -StartTime $updStart `
                                         -EndTime $updEnd

        $updated.Id | Should -Be $script:Worklog.Id
        $updated.GetType().Name | Should -Be 'SDPRequestWorklog'
    }

    It 'Remove-SDPRequestWorklog deletes the worklog' -Skip:($script:Skip -or $script:SkipWorklogs) {
        if (-not $script:Worklog) { Set-ItResult -Skipped -Because 'worklog was not created' ; return }

        { Remove-SDPRequestWorklog -RequestId $script:Request.Id -Id $script:Worklog.Id -Confirm:$false } |
            Should -Not -Throw

        { Get-SDPRequestWorklog -RequestId $script:Request.Id -Id $script:Worklog.Id } |
            Should -Throw

        $script:Worklog = $null
    }
}

# ---------------------------------------------------------------------------
# Request Task Worklog CRUD
# ---------------------------------------------------------------------------

Describe 'RequestTaskWorklog' -Tag Integration {
    BeforeAll {
        if ($script:Skip -or -not $script:Request) { return }

        $script:TaskForWorklog = New-SDPRequestTask -RequestId $script:Request.Id `
                                                    -Title 'Pester task for worklog tests'
    }

    AfterAll {
        if ($script:TaskForWorklog) {
            Remove-SDPRequestTask -RequestId $script:Request.Id `
                                  -Id $script:TaskForWorklog.Id `
                                  -Confirm:$false -ErrorAction SilentlyContinue
        }
    }

    It 'New-SDPRequestTaskWorklog creates a worklog on a task' -Skip:($script:Skip -or $script:SkipWorklogs) {
        if (-not $script:TaskForWorklog) { Set-ItResult -Skipped -Because 'task was not created' ; return }

        $twEnd   = Get-Date
        $twStart = $twEnd.AddMinutes(-15)
        $script:TaskWorklog = New-SDPRequestTaskWorklog -RequestId $script:Request.Id `
                                                        -TaskId $script:TaskForWorklog.Id `
                                                        -Description 'Pester task worklog.' `
                                                        -OwnerId $env:SDP_WORKLOG_OWNER_ID `
                                                        -StartTime $twStart `
                                                        -EndTime $twEnd

        $script:TaskWorklog              | Should -Not -BeNullOrEmpty
        $script:TaskWorklog.Id           | Should -BeGreaterThan 0
        $script:TaskWorklog.RequestId    | Should -Be $script:Request.Id
        $script:TaskWorklog.TaskId       | Should -Be $script:TaskForWorklog.Id
        $script:TaskWorklog.GetType().Name | Should -Be 'SDPRequestTaskWorklog'
    }

    It 'Get-SDPRequestTaskWorklog retrieves the worklog by Id' -Skip:($script:Skip -or $script:SkipWorklogs) {
        if (-not $script:TaskWorklog) { Set-ItResult -Skipped -Because 'task worklog was not created' ; return }

        $fetched = Get-SDPRequestTaskWorklog -RequestId $script:Request.Id `
                                             -TaskId $script:TaskForWorklog.Id `
                                             -Id $script:TaskWorklog.Id
        $fetched.Id | Should -Be $script:TaskWorklog.Id
    }

    It 'Set-SDPRequestTaskWorklog updates the worklog' -Skip:($script:Skip -or $script:SkipWorklogs) {
        if (-not $script:TaskWorklog) { Set-ItResult -Skipped -Because 'task worklog was not created' ; return }

        $twUpdEnd   = Get-Date
        $twUpdStart = $twUpdEnd.AddMinutes(-25)
        $updated = Set-SDPRequestTaskWorklog -RequestId $script:Request.Id `
                                             -TaskId $script:TaskForWorklog.Id `
                                             -Id $script:TaskWorklog.Id `
                                             -StartTime $twUpdStart `
                                             -EndTime $twUpdEnd

        $updated.Id | Should -Be $script:TaskWorklog.Id
        $updated.GetType().Name | Should -Be 'SDPRequestTaskWorklog'
    }

    It 'Remove-SDPRequestTaskWorklog deletes the worklog' -Skip:($script:Skip -or $script:SkipWorklogs) {
        if (-not $script:TaskWorklog) { Set-ItResult -Skipped -Because 'task worklog was not created' ; return }

        { Remove-SDPRequestTaskWorklog -RequestId $script:Request.Id `
                                       -TaskId $script:TaskForWorklog.Id `
                                       -Id $script:TaskWorklog.Id `
                                       -Confirm:$false } | Should -Not -Throw

        $script:TaskWorklog = $null
    }
}

# ---------------------------------------------------------------------------
# Request cleanup (tested explicitly so it appears in results)
# ---------------------------------------------------------------------------

Describe 'Request teardown' -Tag Integration {
    It 'Remove-SDPRequest deletes the test request' -Skip:$script:Skip {
        if (-not $script:Request) { Set-ItResult -Skipped -Because 'request was not created' ; return }

        { Remove-SDPRequest -Id $script:Request.Id -Confirm:$false } | Should -Not -Throw

        { Get-SDPRequest -Id $script:Request.Id } | Should -Throw

        $script:Request = $null
    }
}
