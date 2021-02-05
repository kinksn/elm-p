module Json exposing (..)

import Json.Decode exposing (..)


person = """{ "name": "Tom", "age": 42 }"""

type alias Person =
  { name : String
  , age : Int
  }

personDecoder : Decoder Person
personDecoder =
  map2 Person
      (field "name" string)
      (field "age" int)