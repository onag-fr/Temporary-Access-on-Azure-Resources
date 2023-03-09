Param(
	[Parameter(Mandatory=$false)] [string] $Environment= "",
    [Parameter(Mandatory=$false)] [string] $ResourceGroupName = "",
   	[Parameter(Mandatory=$false)] [string] $AppServiceName = ""
)

$ips = Get-Content "Manage_Access_IPs/Kudu/dev_team_ips.txt" #Path of your txt file that contain the IP to allow/remove
$Conf = Get-AzWebAppAccessRestrictionConfig -ResourceGroupName $ResourceGroupName -Name $AppServiceName

Try {
        if ($ips -eq $null)
                {
                    Write-Host "IP file is empty!"
                }else
                    {
                    foreach ($ip in $ips) 
                        {
                            if ($Conf.ScmSiteAccessRestrictions.IpAddress -eq $ip)
                            {
                                Remove-AzWebAppAccessRestrictionRule `
                                -ResourceGroupName $ResourceGroupName `
                                -WebAppName $AppServiceName `
                                -TargetScmSite `
                                -Name Temp_DEV_IP -IpAddress $ip
                                "IP removed from $AppServiceName in $Environment env.: $ip"
                            }else
                                {
                                    Write-Host "No IP to removed"
                                }
                            }  
                }          
    } Catch {
        Write-Error ("An error occured: $($_.Exception.Message)")
}