<cfscript>
  //API_URL = "https://astral.ctcd.org/api"
  API_URL = "http://192.168.1.72:8000/api"
  data = structNew()
  seats = structKeyExists(form, 'date') && structKeyExists(form, 'students') && structKeyExists(form, 'teachers') && structKeyExists(form, 'parents') 
    ? (toNumeric(form.students) + toNumeric(form.teachers) + toNumeric(form.parents)) 
    : 0
  shows = []
  organizations = []
  events = []
  mocked_events = array()
  fetched_events = []
  
  if (structKeyExists(form, 'date') && seats <= 180) {
    req = new http(method = "GET", charset = "UTF-8", url = API_URL & "/shows")
    shows = deserializeJSON(req.send().getPrefix().filecontent).data
    shows = arrayFilter(shows, function(s) { return s.active != "0" })
    req = new http(method = "GET", charset = "UTF-8", url = API_URL & "/organizations" )
    organizations = deserializeJSON(req.send().getPrefix().filecontent)
    mocked_events = array(
      [ title = "Available", start = form.date & " 09:30:00", end = form.date & " 10:30:00", type_id = 5],
      [ title = "Available", start = form.date & " 10:30:00", end = form.date & " 11:30:00", type_id = 5],
      [ title = "Available", start = form.date & " 11:30:00", end = form.date & " 12:30:00", type_id = 5],
      [ title = "Available", start = form.date & " 12:30:00", end = form.date & " 13:30:00", type_id = 5]
    )
    req = new http(method = "GET", chartset = "UTF-8", url = API_URL & "/public/findAvailableEvents")
    req.addParam(name = "date", type = "url", value = form.date)
    req.addParam(name="seats", type = "url", value = seats)
    fetched_events = deserializeJSON(req.send().getPrefix().filecontent).data
    
    events = arrayFilter(mocked_events, function(e) {
      return !arrayContains(fetched_events, [ 
        title = "Not Available", start = e.start, end = e.end, type_id = e.type_id 
      ])
    })
    
  }
  
  if (structKeyExists(form, "firstname")) {
    data.address = structKeyExists(form, "address") ? form.address : ""
    data.cell = structKeyExists(form, "cell") ?form.cell : ""
    data.city = structKeyExists(form, "city") ? form.city : ""
    data.email = form.email
    // map a "list" to array, loop through the array and build the object below, using indexes
    data.events = arrayMap(listToArray(form.eventdate), function (item, i) {
      return { date: item, show_id: listToArray(form.show_id)[i] }
    }) 
    data.firstname = form.firstname
    data.lastname = form.lastname
    data.email = form.email
    data.memo = form.memo
    data.parents = form.parents
    data.phone = structKeyExists(form, "phone") ? form.phone : ""
    data.postShow = form.postshow
    data.school = form.school
    data.schoolId = structKeyExists(form, "schoolId") ? form.schoolId : ""
    data.special_needs = false //form.special_needs
    data.state = "Texas"
    data.students = form.students
    data.taxable = true
    data.teachers = form.teachers
    data.zip = form.zip
  }
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
        
        <cfif structKeyExists(form, 'date') AND arrayLen(events) <= 0>
          <div class="text-sm p-3 rounded-lg bg-red-100 text-red-600 text-center">
            No events with #seats# seats available were found for #dateFormat(form.date, "full")#.
          </div>
        </cfif>

        <cfif seats GT 180>
          <div class="text-sm p-3 rounded-lg bg-red-100 text-red-600 text-center">
            The maximum number of seats is 180.
          </div>
        </cfif>

        <form class="grid gap-2" method="POST" id="availability" action="">
          <label for="date" class="font-medium text-sm">Date*</label>
          <cfif structKeyExists(form, 'date')>
            <input type="date" placeholder="Date" value="#form.date#" name="date" required class="text-sm rounded-lg border border-zinc-300 w-full md:w-1/3" placeholder="Date" />
          <cfelse>
            <input type="date" placeholder="Date" name="date" min="#dateFormat(dateAdd('d', 7, now()), "yyyy-mm-dd")#" required class="text-sm rounded-lg border border-zinc-300 w-full md:w-1/3" />
          </cfif>
          <span>
            The date you're planning for your field trip. Earliest is 7 days after today.
          </span>
          <h3 class="text-2xl font-extrabold mt-6">Attendance</h3>
          <span>
            Tell us who is coming and how many. We have 180 seats.
          </span>
          <br />
          <div class="grid lg:grid-cols-3 gap-3">
            <div class="grid">
              <label for="students" class="font-medium text-sm">Students *</label>
              <div class="my-3 text-center">
                <span class="text-6xl font-bold" id="students-count">
                  #structKeyExists(form, 'students') ? form.students : 20#
                </span>
              </div>
              <input title="students" type="range" name="students" min="20" max="180" value="#structKeyExists(form, 'students') ? form.students : 20#" required #arrayLen(events) GT 0 ? 'disabled' : ''# />
              <span class="text-zinc-500 text-sm">The total number of students that will be attending the field trip. </span>
            </div>
            <div class="grid">
              <label for="teachers" class="font-medium text-sm">Teachers *</label>
              <div class="my-3 text-center">
                <span class="text-6xl font-bold" id="teachers-count">
                  #structKeyExists(form, 'teachers') ? form.teachers : 2#
                </span>
              </div>
              <input title="teachers" type="range" class="text-blue-900" name="teachers" min="1" max="180" value="#structKeyExists(form, 'teachers') ? form.teachers : 2#" required #arrayLen(events) GT 0 ? 'disabled' : ''# />
              <span class="text-zinc-500 text-sm">For every 10 paying students, 1 adult to supervise the kids is free.</span>
            </div>
            <div class="grid">
              <label for="parents" class="font-medium text-sm">Parents *</label>
              <div class="my-3 text-center">
                <span class="text-6xl font-bold" id="parents-count">
                  #structKeyExists(form, 'parents') ? form.parents : 0#
                </span>
              </div>
              <input title="parents" type="range" name="parents" min="0" max="180" value="#structKeyExists(form, 'parents') ? form.parents : 0#" required #arrayLen(events) GT 0 ? 'disabled' : ''# />
              <span class="text-zinc-500 text-sm">Parents included in the same invoice as students and teachers. </span>
            </div>
          </div>
          <br />
          <div class="grid lg:flex gap-2">
            <button class="btn btn-primary" type="submit" #structKeyExists(form, 'date') ? 'disabled' : ''#>
              Check Availability
            </button>
            <a href="/field-trips" class="btn btn-secondary">
              Start Over
            </a>
          </div>
        </form>

        <cfif arrayLen(events) GT 0 && structKeyExists(form, 'date') && seats <= 180 && seats GT 0>
        <form class="grid gap-2" id="reservation" method="POST" action="/index.cfm/thank-you/">
          <cfif structKeyExists(form, 'date')>
            <input type="hidden" name="date" value="#form.date#" />
          </cfif>
          <cfif structKeyExists(form, 'students')>
            <input type="hidden" name="students" value="#form.students#"/>
          </cfif>
          <cfif structKeyExists(form, 'teachers')>
            <input type="hidden" name="teachers" value="#form.teachers#" />
          </cfif>
          <cfif structKeyExists(form, 'parents')>
            <input type="hidden" name="parents" value="#form.parents#" />
          </cfif>
          <h3 class="text-2xl font-extrabold mt-6">Events and Shows</h3>
          <span class="text-zinc-500">
            Each event lasts between 45 minutes and an hour. <a href="/shows" class="underline underline-offset-2" target="_blank">Click here</a> for more information on our #arrayLen(shows)# shows.
          </span>
          <br />
          <div class="flex items-center bg-blue-100 text-blue-700 gap-2 p-3 rounded-lg">
            <svg role="presentation" viewBox="0 0 24 24" class="w-5 h-5">
              <title>information-outline</title>
                <path d="M11,9H13V7H11M12,20C7.59,20 4,16.41 4,12C4,7.59 7.59,4 12,4C16.41,4 20,7.59 20,12C20,16.41 16.41,20 12,20M12,2A10,10 0 0,0 2,12A10,10 0 0,0 12,22A10,10 0 0,0 22,12A10,10 0 0,0 12,2M11,17H13V11H11V17Z" style="fill: currentcolor;"></path>
              </svg>
            <p class="text-sm">Select a show only for the time slot(s) you want.</p>
          </div>
          <br />
          <fieldset class="grid gap-2">
            <cfloop array="#events#" index="i" item="item">
            <div class="p-3 flex items-center gap-3 border border-zinc-300 rounded-lg">
              <input type="hidden" name="eventdate" value="#item.start#" class="text-blue-900 rounded focus:ring-blue-900" title="Events" />
              <div class="grid gap-2 lg:w-1/2">
                <span class="text-sm font-medium flex items-center gap-2">
                  #dateTimeFormat(item.start, "EEE mmm d @ h:nn tt")#
                </span>
                <select class="rounded-lg border border-zinc-300 text-sm w-full" title="shows" name="show_id" value="0">
                  <option selected value="0">Select a show</option>
                  <cfloop array="#shows#" item="show">
                    <option value="#show.id#">#show.name# (#show.type#, #show.duration# mins)</option>
                  </cfloop>
                </select>
                <span class="text-zinc-500 text-sm">The show that the group will be seeing.</span>
              </div>
            </div>
            </cfloop>
          </fieldset>
          <h3 class="text-2xl font-extrabold mt-6">Post Show</h3>
          <span class="text-zinc-500">
            Select the live presentation you want for your group after the regular show(s).
          </span>
          <br />
          <div class="grid gap-2">
            <div class="flex gap-2">
              <div>
                <input checked type="radio" name="postshow" value="Star Talk" id="startalk" class=" text-sm text-blue-900 focus:ring-blue-900" />
              </div>
              <label for="startalk" class="flex flex-grow items-center">
                <div class="grid">
                  <span>Star Talk</span>
                  <span class="font-normal text-zinc-500">
                    Our staff points out constellations of the current season using the Minolta star projector.
                  </span>
                </div>
              </div>
            </div>
            <div class="flex gap-2">
              <div>
                <input type="radio" name="postshow" value="Uniview" id="uniview" class="text-sm text-blue-900 focus:ring-blue-900" />
              </div>
              <label for="uniview" class="flex flex-grow items-center">
                <div class="grid">
                  <span>Uniview</span>
                  <span class="font-normal text-zinc-500">
                    Live flight around the universe using Uniview 3.0.
                  </span>
                </div>
              </label>
            </div>
          </div>
          <!--- SCHOOL INFORMATION --->
          <h3 class="text-2xl font-extrabold mt-6">School Information</h3>
          <span class="text-zinc-500">
            We need information to create invoices and receipts.
          </span>
          <br />
          <label for="organization">School or Organization *</label>
          <select class="rounded-lg border border-zinc-300 text-sm w-full" id="schoolId" name="schoolId" required>
            <option value="" selected>Select One</option>
            <cfloop array="#organizations#" item="organization">
              <option value="#organization.id#">#organization.name#</option>
            </cfloop>
            <option value="0">My school is not on the list</option>
          </select>
          <span class="text-zinc-500">
            Select your school. Scroll until the very bottom for more options.
          </span>
          <div id="organization-details" style="display:none">
            <label for="school" class="w-full grid gap-1">
              Name *
              <input type="text" name="school" minlength="2" class="text-sm rounded-lg border border-zinc-300" placeholder="Name" />
              <span>The name of the school.</span>
            </label>
            <label for="address" class="w-full grid gap-1">
              Address *
              <input type="text" name="address" minlength="3" class="text-sm rounded-lg border border-zinc-300" placeholder="Address" />
              <span class="text-zinc-500">The address of the school.</span>
            </label>
            <div class="grid lg:grid-cols-2 gap-3">
              <label for="city" class="w-full grid gap-1">
                City*
                <input type="text" name="city" minlength="3" id="school-city" type="text" class="text-sm rounded-lg border border-zinc-300" placeholder="City" />
                <span class="text-zinc-500">The city of the school.</span>
              </label>
              <label for="state" class="w-full grid gap-1">
                State*
                <input type="text" name="state" id="school-state" disabled value="Texas" type="text" class="text-sm rounded-lg border border-zinc-300 bg-zinc-100 cursor-not-allowed" placeholder="The name of the school." />
                <span class="text-zinc-500">State of your school.</span>
              </label>
              <label for="school-zip" class="w-full grid gap-1">
                ZIP*
                <input type="text" name="zip" id="school-zip" minlength="5" maxlength="5" type="text" class="text-sm rounded-lg border border-zinc-300" placeholder="ZIP" />
                <span class="text-zinc-500">ZIP code of the school.</span>
              </label>
              <label for="phone" class="w-full grid gap-1">
                Phone*
                <input type="text" name="phone" id="phone" minlength="10" maxlength="10" type="text" class="text-sm rounded-lg border border-zinc-300" placeholder="Phone" />
                <span class="text-zinc-500">Phone of the school, only numbers, with area code.</span>
              </label>
            </div>
          </div>
          <!--- TEACHER INFORMATION --->
          <h3 class="text-2xl font-extrabold mt-6">Teacher Information</h3>
          <span class="text-zinc-500">
            We need information on the teacher leading the field trip.
          </span>
          <br />
          <div class="grid gap-3 lg:grid-cols-2">
            <label for="firstname" class="w-full grid gap-1">
              First Name*
              <input name="firstname" minlength="2" maxlength="127" type="text" class="text-sm rounded-lg border border-zinc-300" placeholder="First Name" />
              <span class="text-zinc-500">Teacher first name.</span>
            </label>
            <label for="lastname" class="w-full grid gap-1">
              Last Name*
              <input name="lastname" minlength="2" maxlength="127" type="text" class="text-sm rounded-lg border border-zinc-300" placeholder="Last Name" />
              <span class="text-zinc-500">Teacher last name.</span>
            </label>
          </div>
          <div class="grid gap-3 lg:grid-cols-2">
            <label for="email" class="w-full grid gap-1">
              Email*
              <input name="email" type="email" class="text-sm rounded-lg border border-zinc-300" placeholder="Email" />
              <span class="text-zinc-500">Teacher email.</span>
            </label>
            <label for="school-name" class="w-full grid gap-1">
              Phone*
              <input name="cell" minlength="10" maxlength="10" type="text" class="text-sm rounded-lg border border-zinc-300" placeholder="Phone" />
              <span class="text-zinc-500">Teacher phone with area code, numbers only.</span>
            </label>
          </div>
          <h3 class="text-2xl font-extrabold my-6">Confirm Reservation</h3>
          <label for="memo" class="w-full grid gap-1">
            Notes
            <textarea name="memo" class="text-sm rounded-lg border border-zinc-300" placeholder="Notes"></textarea>
            <span class="text-zinc-500">Write us anything that will help with your reservation. Totally optional.</span>
          </label>
          <br />
          <div class="grid lg:flex gap-2">
            <button class="btn btn-success" type="submit">
              Submit
            </button>
            <a href="/field-trips" class="btn btn-secondary">
              Start Over
            </a>
          </div>
        </form>
        </cfif>
        <br />
        <br />
      </main>
      <cfinclude  template="includes/footer.cfm">
      <script src="#$.siteConfig('themeAssetPath')#/js/reservations.js"></script>
    </body>
  </html>
</cfoutput>