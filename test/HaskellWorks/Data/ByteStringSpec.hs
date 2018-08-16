module HaskellWorks.Data.ByteStringSpec where

import Control.Monad
import HaskellWorks.Hspec.Hedgehog
import Hedgehog
import Test.Hspec

import qualified Data.ByteString              as BS
import qualified Data.ByteString.Lazy         as LBS
import qualified HaskellWorks.Data.ByteString as BS
import qualified Hedgehog.Gen                 as G
import qualified Hedgehog.Range               as R

{-# ANN module ("HLint: Ignore Redundant do" :: String) #-}

spec :: Spec
spec = describe "HaskellWorks.Data.ByteStringSpec" $ do
  it "resegment does not modify data" $ requireProperty $ do
    bss       <- forAll $ (BS.pack <$>) <$> G.list (R.linear 0 8) (G.list (R.linear 0 24) (G.word8 R.constantBounded))
    chunkSize <- forAll $ G.int (R.linear 1 4)
    mconcat (BS.resegment chunkSize bss) === mconcat bss
  it "resegment creates correctly sized segments" $ requireProperty $ do
    bss       <- forAll $ (BS.pack <$>) <$> G.list (R.linear 0 8) (G.list (R.linear 0 24) (G.word8 R.constantBounded))
    chunkSize <- forAll $ G.int (R.linear 1 4)
    forM_ (drop 1 (reverse (BS.resegment chunkSize bss))) $ \bs -> do
      (BS.length bs) `mod` chunkSize === 0
  it "resegmentPadded does not modify data" $ requireProperty $ do
    bss       <- forAll $ (BS.pack <$>) <$> G.list (R.linear 0 8) (G.list (R.linear 0 24) (G.word8 R.constantBounded))
    chunkSize <- forAll $ G.int (R.linear 1 4)
    elbs      <- forAll $ pure $ LBS.fromChunks bss
    albs      <- forAll $ pure $ LBS.take (LBS.length elbs) (LBS.fromChunks (BS.resegmentPadded chunkSize bss))
    albs === elbs
  it "resegmentPadded creates correctly sized segments" $ requireProperty $ do
    bss       <- forAll $ (BS.pack <$>) <$> G.list (R.linear 0 8) (G.list (R.linear 0 24) (G.word8 R.constantBounded))
    chunkSize <- forAll $ G.int (R.linear 1 4)
    forM_ (reverse (BS.resegmentPadded chunkSize bss)) $ \bs -> do
      (BS.length bs) `mod` chunkSize === 0