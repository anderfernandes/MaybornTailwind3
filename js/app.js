/**
 * @type HTMLDialogElement
 */
const dialog = document.querySelector("dialog")
/**
 * @type HTMLButtonElement
 */
const showButton = document.querySelector("#menu-button")
/**
 * HTMLButtonElement
 */
const closeButton = document.querySelector("#menu-close-button")

showButton.addEventListener("click", function () {
  dialog.showModal()
})

closeButton.addEventListener("click", function () {
  dialog.close()
})