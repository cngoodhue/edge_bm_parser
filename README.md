# edge_bm_parser

I ran into an issue where I reimaged my machine and needed to reimport my Microsoft Edge bookmarks; however, the "Bookmarks" file I found in %localappdata%\Microsoft\Edge\User Data\Default was not able to be reimported into Edge. Dropping it back into that directory after reimage did not work. But I did find that you can import an HTML bookmarks file into Edge, and after inspecting the Bookmarks file I had I realized it was JSON. So I wrote a parser in PowerShell that would convert the JSON into an HTML format that Edge would accept to reimport my bookmarks.

# How To Use

1. Launch the script.
2. A "Bookmarks.html" file will be created at the root of your local user directory.
3. Enter the full path to the original Bookmarks file you are trying to convert. For example, "%localappdata%\Microsoft\Edge\User Data\Default\Bookmarks".
4. Done! Go to the root of your local user profile and you should see a "Bookmarks.html" file.
5. In Microsoft Edge, import bookmarks from an HTML file.
