<cfoutput>
  <!DOCTYPE html>
  <html lang="en">
    <cfinclude template="includes/html_head.cfm" />
    <body class="flex flex-col items-center bg-zinc-50">
      <main class="w-full min-h-screen z-30 w-full xl:max-w-screen-2xl p-6 flex flex-col gap-3 pt-16">
        <cfinclude template="includes/navbar.cfm" />
        <h1 class="font-extrabold text-3xl my-12">#$.content('title')#</h1>
        #$.dspBody(
          body=$.content('body'), 
          pageTitle='', 
          crumbList=false, 
          showMetaImage=false
        )#
      </main>
      <cfinclude  template="includes/footer.cfm">
    </body>
  </html>
</cfoutput>