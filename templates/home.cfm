<cfoutput>
  <!DOCTYPE html>
  <html lang="en">
    <cfinclude template="includes/html_head.cfm" />
    <body class="bg-white dark:bg-black text-black flex flex-col items-center">
      <div class="w-full h-screen bg-[url('/themes/MaybornTailwind3/images/galaxy-3608029_1920.jpg')] bg-cover z-10"></div>
      <div class="w-full h-screen bg-cover absolute bg-gradient-to-b from-black/90 from-15% to-black/30 z-20"></div>
      <main class="w-full h-screen text-white z-30 w-full xl:max-w-screen-2xl absolute p-6">
        <nav class="p-6 md:p-12 flex w-full items-center z-20">
          <div class="flex justify-center items-center">
            <img class="h-14" src="#$.siteConfig('themeAssetPath')#/images/logo.png" />
          </div>
          <div class="hidden md:flex grow justify-center items-center gap-8 h-full w-full">
            <a href="/" class="text-white font-medium bg-zinc-900 px-6 rounded py-3 flex items-center justify-center hover:underline underline-offset-2">
              Home
            </a>
            <cfset i = m.getBean('content').loadBy(title='Home').getKidsIterator() />
            <cfif i.hasNext()>
              <cfloop condition="i.hasNext()">
                <cfset item = i.next() />
                <a href="#item.getUrl()#" class="text-white font-medium hover:underline underline-offset-2">
                  #item.getMenuTitle()#
                </a>
              </cfloop>
            </cfif>
          </div>
          <div class="flex md:hidden grow justify-end items-center">
            <svg viewBox="0 0 24 24" class="w-6 h-6 text-white" id="menu-button">
              <path fill="currentColor" d="M3,6H21V8H3V6M3,11H21V13H3V11M3,16H21V18H3V16Z"></path>
            </svg>
          </div>
        </nav>
        <section class="flex flex-col justify-center px-6 h-full -mt-20">
          #$.dspBody(
            body=$.content('body'), 
            pageTitle='', 
            crumbList=false, 
            showMetaImage=false
          )#
        </section>
      </main>
      <cfinclude template="includes/footer.cfm" />
    </body>
  </html>
</cfoutput>