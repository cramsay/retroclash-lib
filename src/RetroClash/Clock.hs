{-# LANGUAGE ScopedTypeVariables, NumericUnderscores, PartialTypeSignatures #-}
{-# OPTIONS_GHC -Wno-partial-type-signatures #-}
module RetroClash.Clock
    ( HzToPeriod

    , Seconds
    , Milliseconds
    , Microseconds
    , Nanoseconds

    , ClockDivider
    , risePeriod
    ) where

import Clash.Prelude
import GHC.Natural

type HzToPeriod (rate :: Nat) = Seconds 1 `Div` rate

type Seconds (s :: Nat) = Milliseconds (1_000 * s)
type Milliseconds (ms :: Nat) = Microseconds (1_000 * ms)
type Microseconds (us :: Nat) = Nanoseconds (1_000 * us)
type Nanoseconds (ns :: Nat) = 1_000 * ns

type ClockDivider dom n = n `Div` DomainPeriod dom

risePeriod
    :: forall ps dom. (HiddenClockResetEnable dom, _)
    => SNat ps
    -> Signal dom Bool
risePeriod _ = riseEvery (SNat @(ClockDivider dom ps))
