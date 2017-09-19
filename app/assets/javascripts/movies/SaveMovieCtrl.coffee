
class SaveMovieCtrl

    constructor: (@$log, @OptionCtrl, @MovieService) ->
        @$log.debug "constructing SaveMovieController"
        
        @movie = @MovieService.selectedItem
        @MovieService.view()
        
        @idiomas   = @OptionCtrl.newManyModel('Idioma', @MovieService.idiomasDefault)
        @formatos  = @OptionCtrl.newSingleModel('Formato', @MovieService.formatosDefault)
        @calidades = @OptionCtrl.newSingleModel('Calidad', @MovieService.calidadesDefault)
        @generos   = @OptionCtrl.newManyModel('Género', @MovieService.generosDefault)
        @actores   = @OptionCtrl.newManyModel('Reparto', [])
        
        @panelesDeOpciones = [@idiomas, @formatos, @calidades, @generos, @actores]
        
        @idiomas.setSelected(@movie.idioma)
        @generos.setSelected(@movie.genero)
        @calidades.setSelected(@movie.calidad)
        @formatos.setSelected(@movie.formato)
        @actores.setSelected(@movie.reparto)
        
    refresh: () ->
        @movie.idioma  = @idiomas.getSelected()
        @movie.genero  = @generos.getSelected()
        @movie.calidad = @calidades.getSelected()
        @movie.formato = @formatos.getSelected()
        @movie.reparto = @actores.getSelected()

    save: () ->
        @refresh()
        @MovieService.save(@movie)

controllersModule.controller('SaveMovieCtrl', SaveMovieCtrl)