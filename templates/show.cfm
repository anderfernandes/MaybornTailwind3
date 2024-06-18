<cfscript>
  //API_URL = "https://astral.ctcd.org/api"
  API_URL = "http://192.168.1.72:8000/api"
  req = new http(method = "GET", charset = "UTF-8", url = API_URL & "/shows/" & url.id)
  show = deserializeJSON(req.send().getPrefix().filecontent)
</cfscript>
<cfoutput>
  <!DOCTYPE html>
  <html lang="en">
    <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <link rel="stylesheet" href="https://rsms.me/inter/inter.css">
      <link href="#$.siteConfig('themeAssetPath')#/css/styles.css" rel="stylesheet" />
      <title>
        <cfif isNull(show) OR !isDefined("url.id")>
          Show Not Found - #esapiEncode('html', $.siteConfig('site'))#
          <cfelse>
          Show ###show.id# &middot; #show.name# - #esapiEncode('html', $.siteConfig('site'))#
        </cfif>
      </title>
    </head>
    <body class="flex flex-col items-center bg-zinc-50">
      <main class="w-full min-h-screen z-30 w-full xl:max-w-screen-2xl p-6 flex flex-col gap-3 pt-16 bg-zinc-50">
      <br />
      <cfinclude template="includes/navbar.cfm" />
      <a href="/shows">
        <svg viewBox="0 0 24 24" class="w-6 h-6">
          <path fill="currentColor" d="M20,10V14H11L14.5,17.5L12.08,19.92L4.16,12L12.08,4.08L14.5,6.5L11,10H20Z"></path>
        </svg>
      </a>
      #$.dspBody(
          body=$.content('body'), 
          pageTitle='', 
          crumbList=false, 
          showMetaImage=false
        )#
        <cfif isNull(show) OR !isDefined("url.id")>
          <div class="bg-red-100 text-sm text-red-700 text-base rounded-lg p-3 font-medium flex justify-center items-center gap-2">
            <svg viewBox="0 0 24 24" class="h-5 w-5">
              <path fill="currentColor" d="M11,15H13V17H11V15M11,7H13V13H11V7M12,2C6.47,2 2,6.5 2,12A10,10 0 0,0 12,22A10,10 0 0,0 22,12A10,10 0 0,0 12,2M12,20A8,8 0 0,1 4,12A8,8 0 0,1 12,4A8,8 0 0,1 20,12A8,8 0 0,1 12,20Z"></path>
            </svg>
            This show does not exist.
          </div>
          <cfelse>
          <div class="flex gap-3">
            <div class="border flex-none rounded-lg w-64 h-96 mb-3" style="background-image:url('#replace(show.cover, "http", "https")#') !important;background-size:cover !important"></div>
            <div class="flex flex-col gap-3">
              <h5 class="text-sm text-zinc-400">Show ###show.id#</h5>
              <h1 class="font-extrabold text-3xl">#show.name#</h1>
              <div class="flex gap-3">
                <span class="px-2 bg-black text-white py-1 border border-black font-medium rounded-full items-center gap-1 flex justify-center text-xs">
                  <svg viewBox="0 0 24 24" class="w-4 h-4">
                    <path fill="currentColor" d="M5.5,7A1.5,1.5 0 0,1 4,5.5A1.5,1.5 0 0,1 5.5,4A1.5,1.5 0 0,1 7,5.5A1.5,1.5 0 0,1 5.5,7M21.41,11.58L12.41,2.58C12.05,2.22 11.55,2 11,2H4C2.89,2 2,2.89 2,4V11C2,11.55 2.22,12.05 2.59,12.41L11.58,21.41C11.95,21.77 12.45,22 13,22C13.55,22 14.05,21.77 14.41,21.41L21.41,14.41C21.78,14.05 22,13.55 22,13C22,12.44 21.77,11.94 21.41,11.58Z"></path>
                  </svg>
                  #show.type#
                </span>
                <span class="px-2 py-1 border font-medium border-black rounded-lg flex gap-1 items-center justify-center text-xs">
                  <svg viewBox="0 0 24 24" class="h-4 w-4">
                    <path fill="currentColor" d="M12,20A8,8 0 0,0 20,12A8,8 0 0,0 12,4A8,8 0 0,0 4,12A8,8 0 0,0 12,20M12,2A10,10 0 0,1 22,12A10,10 0 0,1 12,22C6.47,22 2,17.5 2,12A10,10 0 0,1 12,2M12.5,7V12.25L17,14.92L16.25,16.15L11,13V7H12.5Z"></path>
                  </svg>
                  #show.duration# mins
                </span>
              </div>
              <p>#show.description#</p>
            </div>
          </div>
        </cfif>
      </main>
    </body>
  </html>
</cfoutput>