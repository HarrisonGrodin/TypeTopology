\begin{code}

open import MLTT.Spartan
open import UF.Base
open import UF.PropTrunc
open import UF.FunExt
open import UF.Univalence
open import UF.UA-FunExt
open import MLTT.Fin

open import UF.SIP-Examples
open monoid

module UniformContinuityTopos.InternalLanguage
        (pt  : propositional-truncations-exist)
        (fe  : Fun-Ext)
        (M   : Monoid {𝓤})
        where

open import UF.Subsingletons
open import UF.Subsingleton-Combinators
open AllCombinators pt fe

open import UniformContinuityTopos.Coverage pt fe M

\end{code}

\begin{code}

open import UniformContinuityTopos.Sheaf pt fe M

module DefnOfInternalLanguage (𝒸ℴ𝓋 : Coverage 𝓦) where

 open DefnOfSheaf 𝒸ℴ𝓋

 𝒯𝓎𝓅ℯ : 𝓤 ⁺ ⊔ 𝓦  ̇
 𝒯𝓎𝓅ℯ = Sheaf

 private
  variable
   X Y : 𝒯𝓎𝓅ℯ

 data 𝒞𝓉𝓍 : 𝓤 ⁺ ⊔ 𝓦  ̇ where
  ∅    : 𝒞𝓉𝓍
  _⌢_  : 𝒞𝓉𝓍 → 𝒯𝓎𝓅ℯ → 𝒞𝓉𝓍

 infix  4 _∋_
 infixl 5 _⌢_

 private
  variable
   Γ Δ : 𝒞𝓉𝓍

 data _∋_ : 𝒞𝓉𝓍 → 𝒯𝓎𝓅ℯ → 𝓤  ̇ where
  here  : Γ ⌢ X ∋ X
  there : Γ ∋ X → Γ ⌢ Y ∋ X

 data _⊢_ : 𝒞𝓉𝓍 → 𝒯𝓎𝓅ℯ → (𝓤 ⁺) ⊔ 𝓦  ̇ where
  var  : Γ ∋ X → Γ ⊢ X
  _,ᵢ_ : Γ ⊢ X → Γ ⊢ Y → Γ ⊢ (X ×ₛ Y)
  _∘ᵢ_ : Γ ⊢ X → (Γ ⌢ X) ⊢ Y → Γ ⊢ Y

 mutual

  ⟦_⟧ₜ : 𝒞𝓉𝓍 → Sheaf
  ⟦ ∅     ⟧ₜ = 𝟏ₛ
  ⟦ Γ ⌢ X ⟧ₜ = ⟦ Γ ⟧ₜ ×ₛ X

  ⟦_⟧ₓ : Γ ∋ X → ℋℴ𝓂 ⟦ Γ ⟧ₜ X
  ⟦_⟧ₓ {Γ ⌢ X} {X} here      = π₂ ⟦ Γ ⟧ₜ X
  ⟦_⟧ₓ {Γ ⌢ Y} {X} (there p) = {!!}

  𝓉𝓎𝓅ℯ-ℴ𝒻 : Γ ⊢ X → 𝒯𝓎𝓅ℯ
  𝓉𝓎𝓅ℯ-ℴ𝒻 {_} {X} t = X


  ⟦_⟧ : Γ ⊢ X → ℋℴ𝓂 ⟦ Γ ⟧ₜ X
  ⟦_⟧ {Γ} (var i)        = ⟦ i ⟧ₓ
  ⟦_⟧ {Γ} {X} (t₁ ,ᵢ t₂) = pair ⟦ Γ ⟧ₜ (𝓉𝓎𝓅ℯ-ℴ𝒻 t₁) (𝓉𝓎𝓅ℯ-ℴ𝒻 t₂) ⟦ t₁ ⟧ ⟦ t₂ ⟧
  ⟦_⟧ {Γ} {X} (t₁ ∘ᵢ t₂) = comp ⟦ Γ ⟧ₜ (𝓉𝓎𝓅ℯ-ℴ𝒻 t₁) (𝓉𝓎𝓅ℯ-ℴ𝒻 t₂) {!!} ⟦ t₁ ⟧

\end{code}
