#
# Create a new file called "Bookmarks.html" and paste the code below into it.
# 
# <!DOCTYPE NETSCAPE-Bookmark-file-1>
# <!-- This is an automatically generated file.
#      It will be read and overwritten.
#      DO NOT EDIT! -->
# <META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">
# <TITLE>Bookmarks</TITLE>
# <H1>Bookmarks</H1>
# <DL><p>
#

$ogFilePath = Read-Host = "Enter the *FULL* path of the original Edge bookmarks file to be converted"
$bmFilePath = Read-Host = "Enter the *FULL* path of the Bookmarks.html file you created"

$file = Get-Content $ogFilePath
$json = $file | ConvertFrom-Json
$global:outFile = $bmFilePath

# FUNCTION - Deeper #
# This is a recursive function that loops through the nodes of a given array and uses the Write-It function to append/format node properties to the .html file.

function Deeper {
    param(
        [Parameter(Mandatory)][array]$array,
        [Parameter(Mandatory)][int]$depth = 0,
        [Parameter(Mandatory=$false)][int]$maxDepth = $false
    )

    if ($maxDepth -and $depth -eq $maxDepth) { return }

    foreach ($node in $array) {
        if ($node.children -ne $null) { # if node is a folder
            $string = '<DT><H3 ADD_DATE="' + $node.date_added + '" LAST_MODIFIED="' + $node.date_modified + '">' + $node.name + '<H3/>'
            Write-It -Line $string -Depth $depth
            Write-It -Line '<DL><p>' -Depth $depth
            Deeper -Array $node.children -Depth ($depth + 1) -MaxDepth $maxDepth
            Write-It -Line '</p></DL>' -Depth $depth
         } elseif ($node.url -ne $null) { # if node is a bookmark link
            $string = '<DT><A HREF="' + $node.url + '" ADD_DATE="' + $node.date_added + '">' + $node.name + '</A>'
            Write-It -Line $string -Depth $depth
         }
    }
}

# FUNCTION - Write-It #
# This is a function that automates the process of appending new lines to the .html file.

function Write-It {
    param(
        [Parameter(Mandatory)][string]$line,
        [Parameter(Mandatory=$false)][int]$depth = 0
    )

    $tab = "	"

    for ($i = 0; $i -lt $depth; $i += 1) {
        $prepend = $prepend + $tab
    }

    $output = $prepend + $line + "`n"
    $output | Out-File -FilePath $outFile -Append -Encoding ascii
}

if ($json.roots.bookmark_bar) { # if bookmarks bar exists
    $bmString = '<DT><H3 ADD_DATE="' + $json.roots.bookmark_bar.date_added + '" LAST_MODIFIED="' + $json.roots.bookmark_bar.date_modified + '" PERSONAL_TOOLBAR_FOLDER="true">Bookmarks bar</H3>'
    Write-It -Line $bmString
    Write-It -Line '<DL><p>'
    
    Deeper -Array $json.roots.bookmark_bar.children -Depth 1 -MaxDepth 10

    Write-It -Line '</p></DL>'
}

if ($json.roots.other) { # if other bookmarks exists
    $obmString = '<DT><H3 ADD_DATE="' + $json.roots.other.date_added + '" LAST_MODIFIED="' + $json.roots.other.date_modified + '">Other bookmarks</H3>'
    Write-It -Line $obmString
    Write-It '<DL><p>'

    Deeper -Array $json.roots.other.children -Depth 1 -MaxDepth 10

    Write-It -Line '</p></DL>'
}

Write-It -Line '</p></DL>'