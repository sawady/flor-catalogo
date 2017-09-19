package controllers

import javax.inject._
import scala.concurrent.ExecutionContext
import models.Soft
import models.SoftModel

import play.modules.reactivemongo.ReactiveMongoApi

@Singleton
class SoftCtrl @Inject() (val reactiveMongoApi: ReactiveMongoApi) (implicit exec: ExecutionContext) extends Items[Soft] {
  
  val model = SoftModel
  val colName = "soft"

}