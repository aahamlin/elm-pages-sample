module Main exposing (main)

import Api
import Browser exposing (Document, UrlRequest)
import Browser.Navigation as Nav
import Html exposing (..)
import Json.Decode exposing (Value)
import Page exposing (Page)
import Page.Home as Home
import Page.Login as Login
import Page.NotFound as NotFound
import Page.Settings as Settings
import Route exposing (Route(..))
import Session exposing (Session)
import Url exposing (Url)
import Viewer exposing (Viewer)


main : Program Value AppModel AppMsg
main =
    Api.application Viewer.decoder
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        }



-- every model argument *must* contain a session property
-- read about the record type that adds properties


type AppModel
    = Redirect Session
    | NotFound Session
    | Home Home.Model
    | Login Login.Model
    | Settings Settings.Model


type AppMsg
    = UrlChanged Url
    | LinkClicked UrlRequest
    | GotHomeMsg Home.Msg
    | GotLoginMsg Login.Msg
    | GotSettingsMsg Settings.Msg
    | GotSession Session


init : Maybe Viewer -> Url -> Nav.Key -> ( AppModel, Cmd AppMsg )
init maybeViewer url navKey =
    changeRouteTo (Route.fromUrl url)
        (Redirect (Session.fromViewer navKey maybeViewer))


view : AppModel -> Document AppMsg
view model =
    let
        maybeViewer =
            Session.viewer (toSession model)

        viewPage page toMsg config =
            let
                { title, body } =
                    Page.view maybeViewer page config
            in
            { title = title
            , body = List.map (Html.map toMsg) body
            }
    in
    case model of
        Redirect _ ->
            Page.view maybeViewer Page.Other NotFound.view

        NotFound _ ->
            Page.view maybeViewer Page.Other NotFound.view

        Home home ->
            viewPage Page.Home GotHomeMsg (Home.view home)

        Login login ->
            viewPage Page.Login GotLoginMsg (Login.view login)

        Settings settings ->
            viewPage Page.Settings GotSettingsMsg (Settings.view settings)


update : AppMsg -> AppModel -> ( AppModel, Cmd AppMsg )
update msg model =
    case ( msg, model ) of
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

        ( GotHomeMsg subMsg, Home home ) ->
            Home.update subMsg home
                |> updateWith Home GotHomeMsg

        ( GotLoginMsg subMsg, Login login ) ->
            Login.update subMsg login
                |> updateWith Login GotLoginMsg

        ( GotSettingsMsg subMsg, Settings settings ) ->
            Settings.update subMsg settings
                |> updateWith Settings GotSettingsMsg

        ( GotSession session, _ ) ->
            ( Redirect session
            , Route.replaceUrl (Session.navKey session) Route.Home
            )

        ( _, _ ) ->
            -- Catch all case that should never happen, throw err?
            let
                session =
                    toSession model
            in
            ( NotFound session, Cmd.none )



{- Dispatch updates to pages.

   Args
   1. 'subModel' is one of AppModel custom type
   2. 'subMsg' is one of AppMsg custom type
   3. '( subModel, subCmd )' is a function that returns a subModel and subCmd msg

   For example, Login.elm:
   1. subModel from AppModel = Login Login.Model
   2. subMsg from AppMsg = GotLoginMsg Login.Msg
   3. Login.update signature : Login.Msg -> Login.Model -> ( Login.Model, Cmd Login.Msg ), where the dispatcher provides the Login.Msg and Login.Model values and wraps the output in the AppModel/AppMsg types

-}


updateWith : (subModel -> AppModel) -> (subMsg -> AppMsg) -> ( subModel, Cmd subMsg ) -> ( AppModel, Cmd AppMsg )
updateWith toModel toMsg ( subModel, subCmd ) =
    ( toModel subModel
    , Cmd.map toMsg subCmd
    )



-- SUBSCRIPTIONS


subscriptions : AppModel -> Sub AppMsg
subscriptions model =
    case model of
        NotFound _ ->
            Sub.none

        Redirect _ ->
            Session.changes GotSession (Session.navKey (toSession model))

        Home home ->
            Sub.map GotHomeMsg (Home.subscriptions home)

        Login login ->
            Sub.map GotLoginMsg (Login.subscriptions login)

        Settings settings ->
            Sub.map GotSettingsMsg (Settings.subscriptions settings)



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

        -- protected routes redirect to login, if there is not a Viewer
        maybeViewer =
            Session.viewer session
    in
    case ( maybeRoute, maybeViewer ) of
        ( Just Route.Root, _ ) ->
            ( model
            , Route.replaceUrl
                (Session.navKey session)
                Route.Home
            )

        ( Just Route.Home, _ ) ->
            Home.init session
                |> updateWith Home GotHomeMsg

        ( Just Route.Login, _ ) ->
            Login.init session Nothing
                |> updateWith Login GotLoginMsg

        ( Just Route.Logout, _ ) ->
            ( model, Api.logout )

        ( Just Route.Settings, Just _ ) ->
            Settings.init session
                |> updateWith Settings GotSettingsMsg

        ( Just Route.Settings, Nothing ) ->
            Login.init session (Just Route.Settings)
                |> updateWith Login GotLoginMsg

        ( Nothing, _ ) ->
            ( NotFound session, Cmd.none )
