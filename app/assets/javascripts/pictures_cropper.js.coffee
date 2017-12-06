class window.CarrierWaveCropper
  constructor: ->
    preview_size =  Math.round(($('#picturedecorator_image_cropbox').prop('naturalWidth') - 600)/6)
    $('#picturedecorator_image_cropbox').Jcrop
      boxWidth: 600
      aspectRatio: 0 # for free resize
      setSelect: [0, 0, preview_size, preview_size]
      onSelect: @update
      onChange: @update

  update: (coords) =>
    $('#picturedecorator_image_crop_x').val(coords.x)
    $('#picturedecorator_image_crop_y').val(coords.y)
    $('#picturedecorator_image_crop_w').val(coords.w)
    $('#picturedecorator_image_crop_h').val(coords.h)
    @updatePreview(coords)

  updatePreview: (coords) =>
    $('#picturedecorator_image_previewbox').css
      width: Math.round(100/coords.w * $('#picturedecorator_image_cropbox').prop('naturalWidth')) + 'px'
      height: Math.round(100/coords.h * $('#picturedecorator_image_cropbox').prop('naturalHeigh')) + 'px'
      marginLeft: '-' + Math.round(100/coords.w * coords.x) + 'px'
      marginTop: '-' + Math.round(100/coords.h * coords.y) + 'px'


