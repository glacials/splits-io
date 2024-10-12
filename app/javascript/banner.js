// Allows any number of dismissable banners to be placed,
// with dismissal state for each saved in localStorage.
//
// To use, give your banner element the class "banner" and an ID.
// (You must never change the ID, or the dismissal state will be lost.)
// Give the banner an initial display state of "none".
// Inside the banner, place a button with the class "banner-close".
// That's it!
//
// Example in Slim:
//
// # Note: Do not use the d-none Bootstrap helper, as it uses !important.
// .banner#my-banner-name style="display: none"
//   | This is a banner.
//   button.btn.btn-secondary.banner-close Close

const initBanners = function () {
  for (const element of document.getElementsByClassName("banner")) {
    const storageKey = element.id;
    if (localStorage.getItem(storageKey) === "hide") {
      return;
    }
    element.style.display = "block";
  }
};

document.addEventListener("turbolinks:load", initBanners);

document.addEventListener("click", (event) => {
  const element = event.target;
  if (element.classList.contains("banner-close")) {
    const bannerCloseButton = element;
    const banner = bannerCloseButton.closest(".banner");
    if (banner === null) {
      return;
    }
    const storageKey = banner.id;
    localStorage.setItem(storageKey, "hide");
    banner.style.display = "none";
  }
});
