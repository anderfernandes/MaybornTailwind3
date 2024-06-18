<cfoutput>
  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://rsms.me/inter/inter.css">
    <link href="#$.siteConfig('themeAssetPath')#/css/styles.css" rel="stylesheet" />
    <title>#esapiEncode(('html'), $.content('HTMLTitle'))# - #esapiEncode('html', $.siteConfig('site'))#</title>
  </head>
</cfoutput>