<cfoutput>
  <nav class="flex w-full justify-center z-20 fixed bg-white top-0 left-0 px-6 py-3">
    <div class="flex w-full xl:max-w-screen-2xl items-center">
      <div class="flex justify-center items-center">
        <img class="h-14" src="#$.siteConfig('themeAssetPath')#/images/logo.png" />
      </div>
      <div class="hidden md:flex grow justify-center items-center gap-3 h-full w-full">
        <cfif (FindNoCase(m.content('filename'), '/') eq 0)>
        <a href="/" class="text-black font-medium text-sm hover:bg-blue-950 px-3 py-2 hover:text-white hover:rounded">
          Home
        </a>
        <cfelse>
          <a href="/" class="font-medium text-blue-950 border-b-2 border-blue-950 text-sm px-3 py-2 flex items-center justify-center hover:bg-blue-950 hover:text-white hover:bg-blue-950 hover:text-white hover:rounded">
            Home
          </a>
        </cfif>
        <cfset i = m.getBean('content').loadBy(title='Home').getKidsIterator() />
        <cfif i.hasNext()>
          <cfloop condition="i.hasNext()">
            <cfset item = i.next() />
            <cfif (FindNoCase(m.content('filename'), item.getURLTitle()) eq 0)>
            <a href="#item.getUrl()#" class="text-black font-medium text-sm hover:bg-blue-950 px-3 py-2 hover:text-white hover:rounded">
              #item.getMenuTitle()#
            </a>
            <cfelse>
            <a href="#item.getUrl()#" class="font-medium text-sm px-3 py-2 flex items-center justify-center bg-blue-950 text-white rounded">
              #item.getMenuTitle()#
            </a>
            </cfif>
          </cfloop>
        </cfif>
      </div>
      <div class="flex md:hidden grow justify-end items-center">
        <svg viewBox="0 0 24 24" class="w-6 h-6 text-black" id="menu-button">
          <path fill="currentColor" d="M3,6H21V8H3V6M3,11H21V13H3V11M3,16H21V18H3V16Z"></path>
        </svg>
      </div>
    </div>
  </nav>
</cfoutput>