Tom de Jong & Martin Escardo, 20 May 2019.

Combinatory version of Platek-Scott-Plotkin PCF.
Includes (reflexive transitive closure of) operational semantics.

\begin{code}

{-# OPTIONS --without-K --exact-split --safe --no-sized-types --no-guardedness --auto-inline #-}

open import UF.PropTrunc

module DomainTheory.ScottModelOfPCF.PCF (pt : propositional-truncations-exist) where

open import PCF.Combinatory.PCF pt public

\end{code}
