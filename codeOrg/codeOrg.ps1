#This PS1 file needs to be in the root folder of your project. It is the main file that runs your site and defines the sites security, look, etc.

#Start the script and run any pre-pode commands

#-----PRE - webServerStart Commands Region-----#

#Import PS modules on startup. Make sure correct modules and versions are loaded.
Import-Module -Name pode -RequiredVersion 2.12.1
Import-Module -Name pode.web -RequiredVersion 0.8.3

#Import module files. Must be in the root directory, modules folder. File naming is un-important. These are not the same as importing the PS modules above,
#these are the files called "modules" as they contain callable functions to be used in the site.
$ModRoot = "./modules/"
$ModChildren = Get-ChildItem -Path $ModRoot
    foreach ($ModKid in $ModChildren) { Import-Module -Name $ModKid -Force }

#Write the PID to a file. PID is needed for the update mechanism to work
$PID | Out-File -FilePath "./files/configs/pid.txt" -Force
       
#Set Global Site Name
$Global:SiteName = 'Code Organizer'

#-----END - webServerStart Commands Region-----#

#-----CONFIGURE/START WEBSERVER Region-----#

#Start the pode server and set the number of threads
Start-PodeServer -Threads 5 {

    #The following pulls information from the server.psd1 file in the root project folder. This file must be there. Its the "web server" site configuration file.
    #This file contains the port, address, protocol and hostname information along with where you set caching, timeouts, password settings, etc.
    $port = (Get-PodeConfig).Port
    $address = (Get-PodeConfig).Address
    $protocol = (Get-PodeConfig).Protocol
    $hostname = (Get-PodeConfig).Hostname
    
   
    #CREATE ENDPOINT (creates the web page endpoint) - take settings from above and create an endpoint. This is also where you would put your certificate information if using HTTPS.
    Add-PodeEndpoint -Address $address -Hostname $hostname -Port $port -Protocol $protocol
    
    #LOGGING - Creates log files in the path specified. Also sets the name of the logs and the max size before it creates a new log. Error options are (Error,Warning,Information,Debug and Verbose)
    New-PodeLoggingMethod -File -Name 'psCodeOrg_errors' -MaxSize 50MB -MaxDays 90 -Path './Logs/errors' | Enable-PodeErrorLogging -Levels @("Error", "Warning")
    New-PodeLoggingMethod -File -Name 'psCodeOrg_requests' -Path './Logs/requests' -MaxSize 50MB -MaxDays 90 | Enable-PodeRequestLogging
 
    #WEB TEMPLATE - make sure to place favicon and logo in a folder named ./public at the root of the project.
    #This Line sets the default theme, the website title and the security settings.
    Use-PodeWebTemplates -Title $SiteName -Theme Dark -Security Strict -UseHSTS -Favicon '/ToolIcon.png' -Logo '/ToolIcon.png'
    
    #SESSION SETTINGS - durtation 1200 seconds, is extended 1200 seconds on use.
    Enable-PodeSessionMiddleware -Duration 1200 -Extend

    #SET VIEW TYPE - can be set to pode (default), html, etc
    Set-PodeViewEngine -Type Pode
    #-----END - CONFIGURE/START WEBSERVER Region-----#

    #-----SITE PAGES Region-----#
    #Site Pages are stored in ./pages of the main project folder. Using the command Use-PodeWebPages and the path will load the pages when the server starts. This keeps
    #the main body of this file smaller, cleaner and easier to manage
            
    Use-PodeWebPages -Path './Pages/'

    #-----END - SITE PAGES Region-----#
    
    #-----STYLESHEET Region-----#
    #This is a css stylesheet that you can use to define css for the site. Can be used to pre
    #define colors and styles. It also removes the footer about pode and removes the top menu toggle.

    Import-PodeWebStylesheet -Url '/style.css'

    #-----END - STYLESHEET Region

    #-----Top Navigation Region-----#
    #Site Navigation is the top Nav bar of the website. This inlcudes links to outside sites and resources inside, like the about page

    $navAbout = New-PodeWebNavLink -Name 'About' -Url '/pages/AboutHelp' -Icon 'information-outline'
    $navGithubProj = New-PodeWebNavLink -Name 'Project Repo' -Url 'https://github.com/enigma-tek/PSCodeOrganizer' -Icon 'github' -NewTab
    $navDiv = New-PodeWebNavDivider

    Set-PodeWebNavDefault -Items $navDiv, $navGithubProj, $navDiv, $navAbout, $navDiv
    #-----END - Top Navigation Region-----#

} #Main Script closing bracket      
