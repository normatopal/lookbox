ConstantsList = Object.freeze({
  LookCanvasID: "look-canvas",
  ZoomLoupeOptions: {
    zoomType: "lens",
    containLensZoom: true,
    lensShape: "round", //rectangle
    lensSize: 150
  },
  Images: {
    noImageSmall: 'no_image_found.jpg',
    noImageLarge: 'no_image_found_large.jpg',
    rotationAngle: 90,
    rotationClasses: 'rotate0 rotate90 rotate180 rotate270'
  },
  FlashNotice: {
    fadeOutTime: 5000,
    messageClass: '#flash_notice'
  },
  isMobileDevice: "ontouchstart" in window
});

