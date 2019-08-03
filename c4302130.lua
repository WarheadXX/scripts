--Strike Charge Skai
function c4302130.initial_effect(c)
  --Search
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(4302130,0))
  e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
  e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e1:SetCode(EVENT_SPSUMMON_SUCCESS)
  e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
  e1:SetTarget(c4302130.thtg)
  e1:SetOperation(c4302130.thop)
  c:RegisterEffect(e1)
   --Add Back
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(4302130,1))
  e2:SetCategory(CATEGORY_TOHAND)
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e2:SetCode(EVENT_BE_MATERIAL)
  e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
  e2:SetCondition(c4302130.drcon)
  e2:SetTarget(c4302130.thtg2)
  e2:SetOperation(c4302130.thop2)
  c:RegisterEffect(e2)
end

function c4302130.thfil(c)
  return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsType(TYPE_TUNER) and c:IsAbleToHand()
end
function c4302130.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c4302130.thfil,tp,LOCATION_DECK,0,1,nil) end
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
end
function c4302130.thop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectMatchingCard(tp,c4302130.thfil,tp,LOCATION_DECK,0,1,1,nil)
  if g:GetCount()>0 then
	Duel.SendtoHand(g,tp,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
  end
end

function c4302130.drcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_SYNCHRO
end
function c4302130.thfil2(c)
  return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsAbleToHand() and not c:IsType(TYPE_TUNER)
end
function c4302130.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c4302130.thfil2,tp,LOCATION_GRAVE,0,1,nil) end
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
end
function c4302130.thop2(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectMatchingCard(tp,c4302130.thfil2,tp,LOCATION_GRAVE,0,1,1,nil)
  if g:GetCount()>0 then
	Duel.SendtoHand(g,tp,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
  end
end