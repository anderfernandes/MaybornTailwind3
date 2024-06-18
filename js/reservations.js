document.querySelector("input[type=range][name=students]").addEventListener("input", function (e) {
  document.querySelector("#students-count").textContent = e.currentTarget.value
})

document.querySelector("input[type=range][name=teachers]").addEventListener("input", function (e) {
  document.querySelector("#teachers-count").textContent = e.currentTarget.value
})

document.querySelector("input[type=range][name=parents]").addEventListener("input", function (e) {
  document.querySelector("#parents-count").textContent = e.currentTarget.value
})

if (document.querySelector('#schoolId'))
  document.querySelector("#schoolId").onchange = function (e) {
    document.querySelector("#organization-details").style.display = e.currentTarget.value === "0" ? "block" : "none"
  }

// document.querySelectorAll("input[type=checkbox][name=eventdate]").forEach(function (eventsCheckbox, index) {
//   eventsCheckbox.addEventListener("change", function (e) {
//     /**
//      * @type {HTMLSelectElement}
//      */
//     const select = document.querySelectorAll("select[name=show_id]")[index];
//     select.disabled = !select.disabled
//     select.required = !select.required
//   })
// })

if (document.querySelector("#organization")) {
  document.querySelector("#organization").onchange = function (e) {
    document.querySelector("#organization-details").style.display =
      e.currentTarget.value === "0" ? "block" : "none"
  }
}

if (document.querySelector('form#reservation')) {
  document.querySelector('form#reservation').onsubmit = function (e) {
    if (Array.from(document.querySelectorAll("[name=show_id]")).length === 0) {
      e.preventDefault()
      alert("You must select at least one event.")
      //document.querySelector("[name=events]").setCustomValidity("You must select at least one event.")
    }
    if (!confirm("Are you sure?")) e.preventDefault()
    // PREVENT SAME SHOW FROM BEING SELECTED ON SUBMIT
  }
}