import "@ungap/custom-elements"
import "@hotwired/turbo-rails"
import Rails from "@rails/ujs"

import GUI from "alchemy_admin/gui"
import { translate } from "alchemy_admin/i18n"
import Dirty from "alchemy_admin/dirty"
import IngredientAnchorLink from "alchemy_admin/ingredient_anchor_link"
import ImageLoader from "alchemy_admin/image_loader"
import ImageCropper from "alchemy_admin/image_cropper"
import Initializer from "alchemy_admin/initializer"
import pictureSelector from "alchemy_admin/picture_selector"
import pleaseWaitOverlay from "alchemy_admin/please_wait_overlay"
import Sitemap from "alchemy_admin/sitemap"
import SortableElements from "alchemy_admin/sortable_elements"
import Spinner from "alchemy_admin/spinner"
import PagePublicationFields from "alchemy_admin/page_publication_fields"

// Setting jQueryUIs global animation duration to something more snappy
$.fx.speeds._default = 400

// Web Components
import "alchemy_admin/components/button"
import "alchemy_admin/components/char_counter"
import "alchemy_admin/components/datepicker"
import "alchemy_admin/components/dialog_link"
import "alchemy_admin/components/element_editor"
import "alchemy_admin/components/ingredient_group"
import "alchemy_admin/components/node_select"
import "alchemy_admin/components/uploader"
import "alchemy_admin/components/overlay"
import "alchemy_admin/components/page_select"
import "alchemy_admin/components/select"
import "alchemy_admin/components/spinner"
import "alchemy_admin/components/tinymce"
import "@shoelace/progress-bar"
import "@shoelace/switch"
import "@shoelace/tab"
import "@shoelace/tab-group"
import "@shoelace/tab-panel"
import "@shoelace/tooltip"

import { setDefaultAnimation } from "@shoelace/animation-registry"

// Change the default animation for all dialogs
setDefaultAnimation("tooltip.show", {
  keyframes: [
    { transform: "translateY(10px)", opacity: "0" },
    { transform: "translateY(0)", opacity: "1" }
  ],
  options: {
    duration: 100
  }
})

setDefaultAnimation("tooltip.hide", {
  keyframes: [
    { transform: "translateY(0)", opacity: "1" },
    { transform: "translateY(10px)", opacity: "0" }
  ],
  options: {
    duration: 100
  }
})

// Global Alchemy object
if (typeof window.Alchemy === "undefined") {
  window.Alchemy = {}
}

// Enhance the global Alchemy object with imported features
Object.assign(Alchemy, {
  ...Dirty,
  GUI,
  t: translate, // Global utility method for translating a given string
  ImageLoader: ImageLoader.init,
  ImageCropper,
  Initializer,
  IngredientAnchorLink,
  pictureSelector,
  pleaseWaitOverlay,
  Sitemap,
  SortableElements,
  Spinner,
  PagePublicationFields
})

Rails.start()

$(document).on("turbo:load", Initializer)
