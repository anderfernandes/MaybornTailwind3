<cfoutput>
  <footer class="bg-blue-950 p-16 w-full text-white flex justify-center">
    <div class="flex flex-col gap-2 w-full xl:max-w-screen-2xl">
      <span class="font-medium">&copy; #year(now())# #esapiEncode('html', $.siteConfig('site'))#</span>
      <br />
      <span class="text-sm">
        On the Campus of <a href="https://www.ctcd.edu" class="underline" target="_blank">Central Texas College</a>, Bldg No. 267, 
        Bell Tower Drive, 6200 W Central Texas Expy, Killeen, TX 76549
      </span>
    </div>
  </footer>
  <dialog id="menu-dialog" class="w-full h-full p-6 bg-white text-black dark:bg-black dark:text-white rounded-xl border border-white">
    <div class="w-full flex justify-end">
      <button id="menu-close-button">
        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="size-6">
          <path stroke-linecap="round" stroke-linejoin="round" d="M6 18 18 6M6 6l12 12" />
        </svg>
      </button>
    </div>
    <img class="h-28 my-6" src="#$.siteConfig('themeAssetPath')#/images/logo.png" />
    <div class="grid gap-3">
      <a href="/" class="font-medium py-2 text-sm">Home</a>
      <cfset i = m.getBean('content').loadBy(title='Home').getKidsIterator() />
      <cfif i.hasNext()>
        <cfloop condition="i.hasNext()">
          <cfset item = i.next() />
          <a class="font-medium py-2 text-sm" href="#item.getUrl()#">
            #item.getMenuTitle()#
          </a>
        </cfloop>
      </cfif>
    </div>
  </dialog>
  <script src="#$.siteConfig('themeAssetPath')#/js/app.js"></script>
</cfoutput>