<cfscript>
  //API_URL = "https://astral.ctcd.org/api"
  API_URL = "http://192.168.1.72:8000/api"
  start = dateFormat(now(), "yyyy-mm-dd")
  end = dateFormat(now().add("d", 8), "yyyy-mm-dd")
  req = new http(method = "GET", charset = "UTF-8", url = API_URL & "/events/by-date")
  req.addParam(name = "start", type = "url", value = start)
  req.addParam(name = "end", type = "url", value = end)
  data = deserializeJSON(req.send().getPrefix().filecontent).data
  #setTimezone('America/Chicago')#
</cfscript>
<cfoutput>
  <!DOCTYPE html>
  <html lang="en">
    <cfinclude template="includes/html_head.cfm" />
    <body class="flex flex-col items-center bg-zinc-50">
      <main class="w-full h-screen z-30 w-full xl:max-w-screen-2xl p-6 flex flex-col gap-3 pt-16 bg-zinc-50">
        <cfinclude template="includes/navbar.cfm" />
        <h1 class="font-extrabold text-3xl my-12">#$.content('title')#</h1>
        #$.dspBody(
          body=$.content('body'), 
          pageTitle='', 
          crumbList=false, 
          showMetaImage=false
        )#
        <br />
        <cfloop item="item" array="#data#">
        <cfif arrayLen(item.events) GT 0>
          <h2 class="text-lg font-bold flex items-center">
            <svg viewBox="0 0 24 24" class="h-6 h-6 mr-1">
              <path fill="currentColor" d="M7,10H12V15H7M19,19H5V8H19M19,3H18V1H16V3H8V1H6V3H5C3.89,3 3,3.9 3,5V19A2,2 0 0,0 5,21H19A2,2 0 0,0 21,19V5A2,2 0 0,0 19,3Z"></path>
            </svg>
            #dateFormat(parseDateTime(item.date), "dddd mmmm d")#
            (#arrayLen(item.events)# events)
          </h2>
          <section class="w-[calc(100%)]">
            <div class="flex gap-3 overflow-x-auto">
              <cfloop item="e" array="#item.events#">
                <a href="/event?id=#e.id#" class="border hover:scale-105 flex-none rounded-lg w-64 h-96 mb-3" style="background-image:url('#replace(e.show.cover, "http", "https")#') !important;background-size:cover !important">
                  <div class="flex flex-col justify-end gap-1 h-full bg-gradient-to-b from-transparent from-35% to-black rounded-b to-90% p-3">
                    <div class="flex items-center gap-1">
                      <span class="px-2 py-1 font-medium bg-white border border-black rounded-full items-center gap-1 flex items-center text-xs">
                        <svg viewBox="0 0 24 24" class="w-4 h-4">
                          <path fill="currentColor" d="M5.5,7A1.5,1.5 0 0,1 4,5.5A1.5,1.5 0 0,1 5.5,4A1.5,1.5 0 0,1 7,5.5A1.5,1.5 0 0,1 5.5,7M21.41,11.58L12.41,2.58C12.05,2.22 11.55,2 11,2H4C2.89,2 2,2.89 2,4V11C2,11.55 2.22,12.05 2.59,12.41L11.58,21.41C11.95,21.77 12.45,22 13,22C13.55,22 14.05,21.77 14.41,21.41L21.41,14.41C21.78,14.05 22,13.55 22,13C22,12.44 21.77,11.94 21.41,11.58Z"></path>
                        </svg>
                        #e.type.name#
                      </span>
                    </div>
                    <div class="flex items-center gap-1">
                      <span class="px-2 py-1 bg-black text-white font-medium border border-black rounded-lg flex gap-1 items-center text-xs">
                        <svg viewBox="0 0 24 24" class="h-4 w-4">
                          <path fill="currentColor" d="M21.41 11.58L12.41 2.58A2 2 0 0 0 11 2H4A2 2 0 0 0 2 4V11A2 2 0 0 0 2.59 12.42L11.59 21.42A2 2 0 0 0 13 22A2 2 0 0 0 14.41 21.41L21.41 14.41A2 2 0 0 0 22 13A2 2 0 0 0 21.41 11.58M13 20L4 11V4H11L20 13M6.5 5A1.5 1.5 0 1 1 5 6.5A1.5 1.5 0 0 1 6.5 5Z"></path>
                        </svg>
                        #e.show.type#
                      </span>
                    </div>
                    <span class="text-sm text-white">#dateTimeFormat(parseDateTime(e.start), "ddd mmm d @ h:nn tt")#</span>
                    <h5 class="font-bold text-base text-white truncate">#e.show.name#</h5>
                  </div>
                </a>
              </cfloop>
            </div>
          </section>
        </cfif>
      </cfloop>
      </main>
      <cfinclude template="includes/footer.cfm">
    </body>
  </html>
</cfoutput>