
class SaveMusicCtrl

    constructor: (@$log, @OptionCtrl, @MusicService) ->
       @$log.debug "constructing SaveMusicController"
       
       @item = @MusicService.selectedItem
       @MusicService.view()
       
       @tipo         = @OptionCtrl.newSingleModel('Tipo', @MusicService.tipoDefault)
       @idioma       = @OptionCtrl.newManyModel('Idioma (Opcional)', @MusicService.idiomaDefault)
       @calidad      = @OptionCtrl.newSingleModel('Calidad (Opcional)', @MusicService.calidadDefault)
       @genero       = @OptionCtrl.newManyModel('Genero (Opcional)', @MusicService.generoDefault)
       @interprete   = @OptionCtrl.newManyModel('Interprete (Opcional)', [])

       @panelesDeOpciones = [@tipo, @idioma, @calidad, @genero, @interprete]
       
       @tipo.setSelected(@item.tipo)
       @idioma.setSelected(@item.idioma)
       @calidad.setSelected(@item.calidad)
       @genero.setSelected(@item.genero)
       @interprete.setSelected(@item.interprete)
       
    refresh: () ->
       @item.tipo = @tipo.getSelected()
       @item.idioma = @idioma.getSelected()
       @item.calidad = @calidad.getSelected()
       @item.genero = @genero.getSelected()
       @item.interprete = @interprete.getSelected()

    save: () ->
       @refresh()
       @MusicService.save(@item)

controllersModule.controller('SaveMusicCtrl', SaveMusicCtrl)