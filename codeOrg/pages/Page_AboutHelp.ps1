#The about page. Standard information about the tool.
Add-PodeWebPage -Name 'AboutHelp' -DisplayName 'About and Help' -Hide -ScriptBlock {

    New-PodeWebContainer -Content @(

        New-PodeWebText -Value 'Name:' -CssClass 'brightWhite' -Style Bold -InParagraph
        New-PodeWebText -Value 'Code Organizer' -CssClass 'orange' -InParagraph

        New-PodeWebText -Value 'Version:' -CssClass 'brightWhite' -Style Bold -InParagraph
        New-PodeWebText -Value '1.0.0' -CssClass 'orange' -InParagraph

        New-PodeWebText -Value 'Author:' -CssClass 'brightWhite' -Style Bold -InParagraph
        New-PodeWebText -Value 'Enigma-Tek (MCarey)' -CssClass 'orange' -InParagraph

        New-PodeWebText -Value 'Built on:' -CssClass 'brightWhite' -Style Bold -InParagraph
        New-PodeWebText -Value 'PowerShell Core 7.5.1' -CssClass 'orange' -InParagraph

        New-PodeWebParagraph -Elements @(
        New-PodeWebText -Value 'Built using:' -CssClass 'brightWhite' -Style Bold
        New-PodeWebText -Value 'Podw/Pode.Web PowerShell Modules. Pode Version 2.12.1, Pode.Web Version 0.8.3 // ' -CssClass 'orange'
        New-PodeWebLink -Source 'https://badgerati.github.io/Pode.Web/0.8.3/' -Value 'Pode.Web Docs / ' -NewTab
        New-PodeWebLink -Source 'https://badgerati.github.io/Pode/' -Value 'Pode Docs' -NewTab
        )

        New-PodeWebParagraph -Elements @(
        New-PodeWebText -Value 'Colors:' -CssClass 'brightWhite' -Style Bold
        New-PodeWebLink -Source 'https://www.w3schools.com/cssref/css_colors.php' -Value 'CSS Colors' -NewTab
        )

        New-PodeWebParagraph -Elements @(
        New-PodeWebText -Value 'Icons:' -CssClass 'brightWhite' -Style Bold
        New-PodeWebLink -Source 'https://pictogrammers.com/library/mdi/' -Value 'Material Icons' -NewTab
        )

        New-PodeWebLine

        New-PodeWebText -Value 'Questions? Comments? Suggestions? Please email:' -CssClass 'brightWhite' -Style Bold -InParagraph
        New-PodeWebText -Value 'enigma-tek@outlook.com' -CssClass 'orange' -InParagraph

    )#End container

}#End page scriptblock