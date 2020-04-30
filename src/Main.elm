module Main exposing (main)

import Api
import Browser exposing (Document, UrlRequest)
import Browser.Navigation as Nav
import Html exposing (..)
import Page exposing (Page)
import Page.Home as Home
import Page.Login as Login
import Page.NotFound as NotFound
import Page.Settings as Settings
import Route exposing (Route)
import Session exposing (Session)
import Url exposing (Url)



--import Viewer exposing (Viewer)
{- Sample of basic navigation in Elm.

   The first argument is currently empty until we decode the flags from Json.Value
-}


main : Program () AppModel AppMsg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        }



-- every model argument *must* contain a session property


type AppModel
    = Redirect Session
    | NotFound Session
    | Home Home.Model
    | Login Login.Model
    | Settings Settings.Model


type AppMsg
    = UrlChanged Url
    | LinkClicked UrlRequest
    | GoToHome Home.Msg
    | GoToLogin Login.Msg
    | GoToSettings Settings.Msg
    | GotSession Session



-- first argument to init will be Value and then Maybe User


init : () -> Url -> Nav.Key -> ( AppModel, Cmd AppMsg )
init _ url navKey =
    changeRouteTo (Route.fromUrl url)
        (Redirect (Session.fromViewer navKey Nothing))


view : AppModel -> Document AppMsg
view model =
    let
        viewer =
            Session.viewer (toSession model)

        viewPage page toMsg config =
            let
                { title, body } =
                    Page.view viewer page config
            in
            { title = title
            , body = List.map (Html.map toMsg) body
            }
    in
    case Debug.log "view" model of
        Redirect _ ->
            Page.view viewer Page.Other NotFound.view

        NotFound _ ->
            Page.view viewer Page.Other NotFound.view

        Home home ->
            viewPage Page.Home GoToHome (Home.view home)

        Login login ->
            viewPage Page.Login GoToLogin (Login.view login)

        Settings settings ->
            viewPage Page.Settings GoToSettings (Settings.view settings)


update : AppMsg -> AppModel -> ( AppModel, Cmd AppMsg )
update msg model =
    case Debug.log "Main.update" ( msg, model ) of
        ( LinkClicked urlRequest, _ ) ->
            case urlRequest of
                Browser.Internal url ->
                    ( model
                    , Nav.pushUrl
                        (Session.navKey (toSession model))
                        (Url.toString url)
                    )

                Browser.External href ->
                    ( model, Nav.load href )

        ( UrlChanged url, _ ) ->
            changeRouteTo (Route.fromUrl url) model

        ( GoToHome subMsg, Home home ) ->
            Home.update subMsg home
                |> updateWith Home GoToHome

        ( GoToLogin subMsg, Login login ) ->
            Login.update subMsg login
                |> updateWith Login GoToLogin

        ( GoToSettings subMsg, Settings settings ) ->
            Settings.update subMsg settings
                |> updateWith Settings GoToSettings

        ( GotSession session, _ ) ->
            ( Redirect session
            , Route.replaceUrl (Session.navKey session) Route.Home
            )

        ( _, _ ) ->
            -- Catch all case that should never happen, throw err?
            ( model, Cmd.none )


updateWith : (subModel -> AppModel) -> (subMsg -> AppMsg) -> ( subModel, Cmd subMsg ) -> ( AppModel, Cmd AppMsg )
updateWith toModel toMsg ( subModel, subCmd ) =
    ( toModel subModel
    , Cmd.map toMsg subCmd
    )



-- SUBSCRIPTIONS


subscriptions : AppModel -> Sub AppMsg
subscriptions model =
    case Debug.log "Main.subscriptions" model of
        NotFound _ ->
            Sub.none

        Redirect _ ->
            Session.changes GotSession (Session.navKey (toSession model))

        Home home ->
            Sub.map GoToHome (Home.subscriptions home)

        Login login ->
            Sub.map GoToLogin (Login.subscriptions login)

        Settings settings ->
            Sub.map GoToSettings (Settings.subscriptions settings)



-- ROUTER


toSession : AppModel -> Session
toSession model =
    case model of
        NotFound session ->
            session

        Redirect session ->
            session

        Home m ->
            m.session

        Login m ->
            m.session

        Settings m ->
            m.session


changeRouteTo : Maybe Route -> AppModel -> ( AppModel, Cmd AppMsg )
changeRouteTo maybeRoute model =
    let
        session =
            toSession model
    in
    case maybeRoute of
        Just Route.Root ->
            ( model
            , Route.replaceUrl
                (Session.navKey session)
                Route.Home
            )

        Just Route.Home ->
            Home.init session
                |> updateWith Home GoToHome

        Just Route.Login ->
            Login.init session
                |> updateWith Login GoToLogin

        Just Route.Settings ->
            Settings.init session
                |> updateWith Settings GoToSettings

        Just Route.Logout ->
            ( model, Api.logout )

        Nothing ->
            ( NotFound session, Cmd.none )
