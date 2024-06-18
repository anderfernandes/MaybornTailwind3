<cfscript>
  API_URL = "http://192.168.1.72:8000/api"
  req = new http(method = "GET", chartset = "UTF-8", url = API_URL & "/shows")
  shows = deserializeJSON(req.send().getPrefix().filecontent).data
  shows = arrayFilter(shows, function(s) { return s.active != "0" })
  if (structKeyExists(url, 'name') AND stringLen(url.name) GT 0) {
    shows = arrayFilter(shows, function (s) { return findNoCase(url.name, s.name, 0) != 0 })
  }
  if (structKeyExists(url, 'type') AND stringLen(url.type) GT 0) {
    shows = arrayFilter(shows, function (s) { return lCase(s.type) == lCase(url.type) })
  }
</cfscript>
<cfoutput>
  <!DOCTYPE html>
  <html lang="en">
    <cfinclude template="includes/html_head.cfm" />
    <body class="flex flex-col items-center bg-zinc-50">
      <main class="w-full min-h-screen z-30 w-full xl:max-w-screen-2xl p-6 flex flex-col gap-3 pt-16 bg-zinc-50">
        <br /><br />
        <cfinclude template="includes/navbar.cfm" />
        <h1 class="font-extrabold text-3xl">#$.content('title')#</h1>
        #$.dspBody(
          body=$.content('body'), 
          pageTitle='', 
          crumbList=false, 
          showMetaImage=false
        )#
        <br />
        <form class="grid md:flex gap-3" action="" method="GET">
          <input type="text" name="name" placeholder="Name" class="rounded-lg border border-zinc-300 text-sm w-full md:w-1/5" value="#structKeyExists(url, 'name') ? url.name : ''#" />
          <select class="rounded-lg border border-zinc-300 text-sm w-full md:w-1/5" name="type">
            <option value="">Select a type</option>
            <option value="Planetarium" #structKeyExists(url, 'type') AND lCase(url.type) == 'planetarium' ? 'selected' : ''#>Planetarium</option>
            <option value="Laser Light" #structKeyExists(url, 'type') AND lCase(url.type) == 'laser light' ? 'selected' : ''#>Laser Light</option>
          </select>
          <button class="btn btn-primary" type="submit">Filter</button>
        </form>
        <br />
        <section class="flex flex-col items-center lg:grid lg:grid-cols-5 gap-3">
          <cfif arrayLen(shows) EQ 0>
            <span class="text-sm">No shows found.</span>
          <cfelse>
          <cfloop item="show" array="#shows#">
            <a href="/show?id=#show.id#" class="hover:scale-105 border flex-none rounded-lg w-64 h-96 mb-3" style="background-image:url('#replace(show.cover, "http", "https")#') !important;background-size:cover !important">
              <div class="flex flex-col justify-end gap-1 h-full bg-gradient-to-b from-transparent from-35% to-black rounded-b to-90% p-3">
                <div class="flex items-center gap-1">
                  <span class="px-2 py-1 bg-black text-white font-medium border border-black rounded-lg flex gap-1 items-center text-xs">
                    <svg viewBox="0 0 24 24" class="h-4 w-4">
                      <path fill="currentColor" d="M21.41 11.58L12.41 2.58A2 2 0 0 0 11 2H4A2 2 0 0 0 2 4V11A2 2 0 0 0 2.59 12.42L11.59 21.42A2 2 0 0 0 13 22A2 2 0 0 0 14.41 21.41L21.41 14.41A2 2 0 0 0 22 13A2 2 0 0 0 21.41 11.58M13 20L4 11V4H11L20 13M6.5 5A1.5 1.5 0 1 1 5 6.5A1.5 1.5 0 0 1 6.5 5Z"></path>
                    </svg>
                    #show.type#
                  </span>
                </div>
                <h5 class="font-bold text-base text-white truncate">#show.name#</h5>
              </div>
            </a>
          </cfloop>
          </cfif>
        </section>
      </main>
      <cfinclude  template="includes/footer.cfm">
    </body>
  </html>
</cfoutput>