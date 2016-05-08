-- |
-- Copyright: 2016 John Ky
-- License: MIT
--
-- Tree Cursor
module HaskellWorks.Data.TreeCursor
    ( TreeCursor(..)
    ) where

import           HaskellWorks.Data.Positioning

class TreeCursor k where
  firstChild :: k -> Maybe k
  nextSibling :: k -> Maybe k
  parent :: k -> Maybe k
  depth :: k -> Count
  subtreeSize :: k -> Count
