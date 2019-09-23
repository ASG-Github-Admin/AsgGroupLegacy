function New-EncryptedPasswordFile {
    
    <#
    .SYNOPSIS
    Creates a file with a password as an encrypted string.

    .DESCRIPTION
    This function converts the specified secure string password to an encrypted string, and outputs it to the
    specified file system path.

    .EXAMPLE
    PS C:\PS> New-EncryptedPasswordFile -Path "C:\PowerShell Passwords\Passwd.txt"

    Description
    -----------
    This creates an encrypted password file 'Passwd.txt' in the 'C:\PowerShell Passwords' directory.

    .EXAMPLE
    PS C:\PS> New-EncryptedPasswordFile -Path "C:\PowerShell Passwords\Passwd.txt"

    Description
    -----------
    This creates an encrypted password file 'Passwd.txt' in the 'C:\PowerShell Passwords' directory.

    .PARAMETER Password
    Specifies a secure string object containing the password.

    .PARAMETER Path
    Specifies a path for the file to be created.

    .INPUTS
    securestring, System.String

    You can pipe a file system path (in quotation mark) to this function.

    .OUTPUTS
    None

    Creates a file using the specified file path.
    #>
    
    [CmdLetBinding()]
    param (

        # Output file path
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [ValidateScript(
            
            # Parent directory path validation
            { Split-Path -Path $PSItem -Parent | Test-Path -PathType Container }
        )]
        [Alias("File", "FilePath")]
        [string] $Path,

        # Output file path
        [Parameter(Mandatory, ValueFromPipeline)]
        [ValidateNotNull()]
        [Alias("Pass", "Passwd")]
        [securestring] $Password
    )

    begin {

        # Error handling
        Set-StrictMode -Version "Latest"
        Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
        $CallerEA = $ErrorActionPreference
        $ErrorActionPreference = "Stop"
    }

    process {

        try {

            # Encrypted string out to file path
            Write-Debug -Message "Converting to encrypted string  and writing to '$Path'"
            Write-Verbose -Message "Saving password as an encrypted string"
            ConvertFrom-SecureString -SecureString $Password | Out-File -FilePath $Path -Force
        }
        catch { Write-Error -ErrorRecord $PSItem -ErrorAction $CallerEA }
    }
}