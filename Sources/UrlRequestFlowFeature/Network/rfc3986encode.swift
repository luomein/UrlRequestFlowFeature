//
//  File.swift
//  
//
//  Created by MEI YIN LO on 2023/5/15.
//

import Foundation

func rfc3986encode(_ str: String) -> String
{
  let allowed = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ-._~"
  let allowedSet = CharacterSet(charactersIn: allowed)
  
  return str.addingPercentEncoding(withAllowedCharacters: allowedSet) ?? str
}
