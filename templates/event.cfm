<cfscript>
  //API_URL = "https://astral.ctcd.org/api"
  API_URL = "http://192.168.1.72:8000/api"
  try {
    req = new http(method = "GET", charset = "UTF-8", url= API_URL & "/event/" & url.id)
    data = deserializeJSON(req.send().getPrefix().filecontent)
    tickets = data.allowedTickets.filter(function (t) { return t.public })
  } catch (any e) {
    data = nullValue()
  }
  #setTimezone('America/Chicago')#
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
        <cfif isNull(data) OR !isDefined("url.id")>
          Event Not Found - #esapiEncode('html', $.siteConfig('site'))#
          <cfelse>
          Event ###data.id# - #esapiEncode('html', $.siteConfig('site'))#
        </cfif>
      </title>
    </head>
    <body class="flex flex-col items-center bg-zinc-50">
      <main class="w-full min-h-screen z-30 w-full xl:max-w-screen-2xl p-6 flex flex-col gap-3 pt-16 bg-zinc-50">
        <br />
        <cfinclude template="includes/navbar.cfm" />
        <a href="/schedule">
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
        <cfif isNull(data) OR !isDefined("url.id")>
          <div class="bg-red-100 text-sm text-red-700 text-base rounded-lg p-3 font-medium flex justify-center items-center gap-2">
            <svg viewBox="0 0 24 24" class="h-5 w-5">
              <path fill="currentColor" d="M11,15H13V17H11V15M11,7H13V13H11V7M12,2C6.47,2 2,6.5 2,12A10,10 0 0,0 12,22A10,10 0 0,0 22,12A10,10 0 0,0 12,2M12,20A8,8 0 0,1 4,12A8,8 0 0,1 12,4A8,8 0 0,1 20,12A8,8 0 0,1 12,20Z"></path>
            </svg>
            This event does not exist.
          </div>
          <cfelse>
            <cfif parseDateTime(data.start) LT now()>
              <div class="bg-yellow-100 text-sm text-yellow-700 text-base rounded-lg p-3 font-medium flex justify-center items-center gap-2">
                <svg viewBox="0 0 24 24" class="h-5 w-5">
                  <path fill="currentColor" d="M12,2L1,21H23M12,6L19.53,19H4.47M11,10V14H13V10M11,16V18H13V16"></path>
                </svg>
                This event already happened.
              </div>
            </cfif>
            <div class="flex flex-col items-center md:items-start md:flex-row gap-3 w-full">
              <div class="border flex-none rounded-lg w-64 h-96 mb-3" style="background-image:url('#replace(data.show.cover, "http", "https")#') !important;background-size:cover !important"></div>
              <div class="flex flex-col gap-2 text-center lg:text-left w-full">
                <h5 class="text-sm text-zinc-400">Event ###data.id#</h5>
                <h1 class="font-extrabold text-3xl">#data.show.name#</h1>
                <h4 class="text-base font-medium">
                  #dateTimeFormat(parseDateTime(data.start), "dddd mmm d yyyy @ h:nn tt")#
                  <cfif data.seats LT data.capacity>
                    &middot; #data.seats# seats left
                  </cfif>
                </h4>
                <div class="flex gap-3 justify-center lg:justify-start">
                  <span class="px-2 py-1 bg-white border border-black font-medium rounded-full items-center gap-1 flex justify-center text-xs">
                    <svg viewBox="0 0 24 24" class="w-4 h-4">
                      <path fill="currentColor" d="M5.5,7A1.5,1.5 0 0,1 4,5.5A1.5,1.5 0 0,1 5.5,4A1.5,1.5 0 0,1 7,5.5A1.5,1.5 0 0,1 5.5,7M21.41,11.58L12.41,2.58C12.05,2.22 11.55,2 11,2H4C2.89,2 2,2.89 2,4V11C2,11.55 2.22,12.05 2.59,12.41L11.58,21.41C11.95,21.77 12.45,22 13,22C13.55,22 14.05,21.77 14.41,21.41L21.41,14.41C21.78,14.05 22,13.55 22,13C22,12.44 21.77,11.94 21.41,11.58Z"></path>
                    </svg>
                    #data.type#
                  </span>
                  <span class="px-2 bg-black text-white py-1 border font-medium border-black rounded-lg flex gap-1 items-center justify-center text-xs">
                    <svg viewBox="0 0 24 24" class="h-4 w-4">
                      <path fill="currentColor" d="M21.41 11.58L12.41 2.58A2 2 0 0 0 11 2H4A2 2 0 0 0 2 4V11A2 2 0 0 0 2.59 12.42L11.59 21.42A2 2 0 0 0 13 22A2 2 0 0 0 14.41 21.41L21.41 14.41A2 2 0 0 0 22 13A2 2 0 0 0 21.41 11.58M13 20L4 11V4H11L20 13M6.5 5A1.5 1.5 0 1 1 5 6.5A1.5 1.5 0 0 1 6.5 5Z"></path>
                    </svg>
                    #data.show.type#
                  </span>
                </div>
                <br />
                <div class="grid lg:grid-cols-4 gap-3">
                <cfloop item="ticket" array="#tickets#">
                  <div class="p-3 rounded-lg border border-zinc-400 text-sm flex gap-2 items-center">
                    <svg viewBox="0 0 24 24" class="w-5 h-5">
                      <path fill="currentColor" d="M4,4A2,2 0 0,0 2,6V10A2,2 0 0,1 4,12A2,2 0 0,1 2,14V18A2,2 0 0,0 4,20H20A2,2 0 0,0 22,18V14A2,2 0 0,1 20,12A2,2 0 0,1 22,10V6A2,2 0 0,0 20,4H4M4,6H20V8.54C18.76,9.25 18,10.57 18,12C18,13.43 18.76,14.75 20,15.46V18H4V15.46C5.24,14.75 6,13.43 6,12C6,10.57 5.24,9.25 4,8.54V6Z"></path>
                    </svg>
                    <span class="font-medium">#ticket.name#</span>
                    <span>$#ticket.price# each</span>
                  </div>
                </cfloop>
                </div>
              </div>
            </div>
            <p>#data.show.description#</p>
        </cfif>
      </main>
      <cfinclude  template="includes/footer.cfm">
    </body>
  </html>
</cfoutput>