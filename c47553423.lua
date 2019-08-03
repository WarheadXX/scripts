--Gravekeeper's Overseer
function c47553423.initial_effect(c)
  --Special Summon
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_FIELD)
  e1:SetCode(EFFECT_SPSUMMON_PROC)
  e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
  e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
  e1:SetCondition(c47553423.hspcon)
  e1:SetOperation(c47553423.hspop)
  c:RegisterEffect(e1)
  --BRING BACK THOSE GRAVEKEEPER'S THO
  local e2=Effect.CreateEffect(c)
  e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e2:SetRange(LOCATION_MZONE)
  e2:SetCountLimit(1)
  e2:SetTarget(c47553423.target)
  e2:SetOperation(c47553423.operation)
  c:RegisterEffect(e2)
  --immune to necro valley
  local e3=Effect.CreateEffect(c)
  e3:SetType(EFFECT_TYPE_FIELD)
  e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
  e3:SetCode(EFFECT_NECRO_VALLEY_IM)
  e3:SetRange(LOCATION_MZONE)
  e3:SetTargetRange(1,0)
  c:RegisterEffect(e3)
  --summon condition
  local e4=Effect.CreateEffect(c)
  e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
  e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
  e4:SetCode(EVENT_SUMMON_SUCCESS)
  e4:SetOperation(c47553423.sumsuc)
  c:RegisterEffect(e4)
  local e5=e4:Clone()
  e5:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
  e5:SetOperation(c47553423.tgreg2)
  c:RegisterEffect(e5)
   local e6=e5:Clone()
  e6:SetCode(EVENT_SPSUMMON_SUCCESS)
  e6:SetOperation(c47553423.tgreg3)
  c:RegisterEffect(e6)
  --indes, cannot be tributed and cannot be sent to grave
  local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e7:SetValue(1)
	e7:SetCondition(c47553423.incon)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EFFECT_UNRELEASABLE_SUM)
	c:RegisterEffect(e9)
	local e10=e9:Clone()
	e10:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e10)
	local e11=e10:Clone()
	e11:SetCode(EFFECT_CANNOT_TO_GRAVE)
	c:RegisterEffect(e11)
 end
   
 function c47553423.hspfil(c)
  return c:IsSetCard(46)
end
function c47553423.hspcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-1
		and Duel.CheckReleaseGroup(c:GetControler(),c47553423.hspfil,1,nil)
end
function c47553423.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(tp,c47553423.hspfil,1,1,nil)
	Duel.Release(g,REASON_COST)
end

function c47553423.filter(c,e,tp)
	return c:IsSetCard(46)
		and (c:IsCanBeSpecialSummoned(e,0,tp,false,false) or c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN))
end
function c47553423.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c47553423.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c47553423.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c47553423.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		local spos=0
		if tc:IsCanBeSpecialSummoned(e,0,tp,false,false) then spos=spos+POS_FACEUP_DEFENSE end
		if tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN) then spos=spos+POS_FACEDOWN_DEFENSE end
		Duel.SpecialSummon(tc,0,tp,tp,false,false,spos)
		if tc:IsFacedown() then
			Duel.ConfirmCards(1-tp,tc)
	end
	end
	end
	
function c47553423.tgreg1(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(47553423,RESET_EVENT+0x1ec0000+RESET_PHASE+PHASE_END,0,1)
end
function c47553423.tgreg2(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(47553423,RESET_EVENT+0x1fc0000+RESET_PHASE+PHASE_END,0,1)
end
function c47553423.tgreg3(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(47553423,RESET_EVENT+0x1fc0000+RESET_PHASE+PHASE_END,0,1)
end
function c47553423.incon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(47553423)>0
end