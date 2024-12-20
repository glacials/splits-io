// Allows any number of dismissable banners to be placed,
// with dismissal state for each saved in local storage.
//
// To use, give your banner element the class "banner" and an ID.
// (You must never change the ID, or the dismissal state will be lost.)
// Give the banner a style of "display: none"
// (do not use the d-none Bootstrap helper, as it uses !important).
//
// Inside the element,
// place a button with the class "banner-close".
// That's it!
//
// To limit a banner to a specific time period,
// add data-from and data-to attributeseach containing an RFC3339 date string.
// The banner will only be considered for display if the current date is between the two dates.
//
// Example in Slim:
//
// .banner#my-banner-name style="display: none" data={from: "2025-01-05T09:00:00-08:00", to: "2025-01-12T00:15:00-08:00"}
//   | This is a banner.
//   button.btn.btn-secondary.banner-close Close

const initBanners = function () {
  for (const element of document.getElementsByClassName("banner")) {
    const storageKey = element.id;
    if (localStorage.getItem(storageKey) === "hide") {
      return;
    }
    if (element.dataset.from && element.dataset.to) {
      const from = new Date(element.dataset.from);
      const to = new Date(element.dataset.to);
      to.setDate(to.getDate() + 1); // Make the end date inclusive
      const now = new Date();
      if (now < from || now > to) {
        continue;
      }
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
