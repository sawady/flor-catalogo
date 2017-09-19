
class MovieService

    constructor: (@$log, @$location, @OptionCtrl, @ItemService, @$modal, @UsersService, @PageService) ->
        @$log.debug "constructing MovieService"
        
        @search  = {}
        @results = []
        @selectedItem = {}
        
        @marco = "marco_movies.png"
        
        @totalItems = 0
        
        @idiomasDefault = ['Latino','Español','Inglés', 'Japonés', 'Subtitulado']
        @formatosDefault = ['AVI', 'MP4', 'MKV', 'MT2', 'ISO']
        @calidadesDefault = ['DVDRip', 'BRip 720p', 'BRip 1080p', 'DVD', 'DVDFULL', 'HDRip']
        @generosDefault = ['Acción', 'Anime', 'Aventura', 'Bélica', 'Ciencia Ficción', 'Comedia', 'Documental', 'Drama', 'Infantil', 'Intriga', 'Musical', 'Romántica', 'Suspenso', 'Terror', 'Thriller', 'Western']

        @idiomas   = @OptionCtrl.newManyModel('Idioma', @idiomasDefault)
        @formatos  = @OptionCtrl.newSingleModel('Formato', @formatosDefault)
        @calidades = @OptionCtrl.newSingleModel('Calidad', @calidadesDefault)
        @generos   = @OptionCtrl.newManyModel('Género', @generosDefault)
        @actores   = @OptionCtrl.newManyModel('Reparto', [])
        
        @panelesDeOpciones = [@idiomas, @calidades, @formatos, @generos, @actores]
        
    view: () ->
        @ItemService.viewMovies()
                
    initializeService: () ->
        @view()
        @pageCtrl = @PageService.newPageCtrl(this)
        @getItems()
        
    thereAreItems: () ->
        return @results.length > 0

    resetSearch: () ->
        @search = {}
        p.reset() for p in @panelesDeOpciones
        @pageCtrl.setPage(1)

    createItem: () ->
        @selectedItem = {}
        @ItemService.createForm()

    updateItem: (item) ->
        @selectedItem = item
        @ItemService.updateForm()

    deleteItem: (item) ->
        @ItemService.delete(item)
              .then(
                   (data) =>
                      @getItems()
                   ,
                   (error) =>
                      @$log.error "Unable to delete #{error}"
                   )

    setInfoFromOptionPanels: () ->
       @search.idioma = @idiomas.getSelected()
       @search.calidad = @calidades.getSelected()
       @search.formato = @formatos.getSelected()
       @search.genero = @generos.getSelected()
       @search.reparto = @actores.getSelected()
        
    getItems: (aPage = 1) ->
       @$log.debug "getAllMovies() like #{angular.toJson(@search)}"
       
       @pageCtrl.setPage(aPage)
       @setInfoFromOptionPanels()
       
       @ItemService.filterNullProps(@search)

       toDB =
            search: @search
            validKeys: Object.keys(@search)
            page: aPage
       
       @countMovies(toDB)
					
       @ItemService.list(toDB)
              .then(
                   (data) =>
                      @$log.debug "Promise returned #{data.length} Movies"
                      @results = data
                   ,
                   (error) =>
                      @$log.error "Unable to get Movies: #{error}"
                      @search  = {}
                      @results = []
                   )

    countMovies: (toDB) ->
       @ItemService.count(toDB)
       .then(
             (data) =>
               @$log.debug "There are #{data.count} movies in total"
               @totalItems = data.count
             ,
             (error) =>
               @$log.error "Unable to get count of Movies: #{error}"
       )
       
    save: (item) ->
       @ItemService.save(item)
       .then(
           (data) =>
               @$log.debug "Promise returned #{data} Movie"
               @$location.path("/movies")
           ,
           (error) =>
               @$log.error "Unable to create Movie: #{error}"
           )
       
    puedeBorrar: () ->
       @UsersService.isAdmin()
       
    puedeAgregar: () ->
       @UsersService.isUploader("movies")
    
    puedeEditar: (item) ->
       @UsersService.isUploader("movies", item)

    puedeBuscarPost: () ->
       !@UsersService.isInvitado()
        
    openOnDelete: (item) ->
    
      modalCtrl = ($scope, $modalInstance, item) ->
          $scope.item = item
          
          $scope.ok = () ->
              $modalInstance.close(true)

          $scope.cancel = () ->
              $modalInstance.dismiss(false)
    
      modalInstance = @$modal.open(
          templateUrl: '/assets/partials/modals/onDeleteModal.html'
          controller: modalCtrl
          item: item
          resolve: 
             item: () -> item
      )
                    
      loggg  = @$log
      m = this
      
      onOk = (answer) -> 
                 loggg.info('Accepted deletion') if answer
                 m.deleteItem(item)
        
      onOther = () -> loggg.info('Modal dismissed at: ' + new Date())
       
      modalInstance.result.then(onOk, onOther)

    hasLang: (m, lang) ->
       if lang
          return lang in m.idioma
       else
          return m.idioma

servicesModule.service('MovieService', MovieService)