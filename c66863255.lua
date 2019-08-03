--Xyz Superhero
function c66863255.initial_effect(c)
	--lv change
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(66863255,1))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c66863255.cost2)
	e1:SetTarget(c66863255.tg2)
	e1:SetOperation(c66863255.op2)
	c:RegisterEffect(e1)
	--Recover (self)
  	local e2=Effect.CreateEffect(c)
  	e2:SetDescription(aux.Stringid(66863255,0))
  	e2:SetCategory(CATEGORY_TOHAND)
  	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
  	e2:SetRange(LOCATION_GRAVE)
  	e2:SetCountLimit(1,66863255+EFFECT_COUNT_CODE_DUEL)
  	e2:SetCondition(c66863255.thcon)
  	e2:SetTarget(c66863255.thtg)
  	e2:SetOperation(c66863255.thop)
  	c:RegisterEffect(e2)
	--Xyz Count as 2
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetOperation(c66863255.spop2)
	c:RegisterEffect(e3)
	if not c66863255.global_check then
		c66863255.global_check=true
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge3:SetCode(EVENT_ADJUST)
		ge3:SetCountLimit(1)
		ge3:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge3:SetOperation(c66863255.xyzchk)
		Duel.RegisterEffect(ge3,0)
end
end

function c66863255.costfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsDiscardable()
end
function c66863255.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c66863255.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c66863255.costfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c66863255.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local t={}
	local i=1
	local p=1
	local lv=e:GetHandler():GetLevel()
	for i=1,8 do 
		if lv~=i then t[p]=i p=p+1 end
	end
	t[p]=nil
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(66863255,1))
	e:SetLabel(Duel.AnnounceNumber(tp,table.unpack(t)))
end
function c66863255.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(e:GetLabel())
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
	end
end

function c66863255.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=eg:GetFirst()
	return c:IsControler(tp) and bit.band(c:GetSummonType(),SUMMON_TYPE_XYZ)==SUMMON_TYPE_XYZ
end
function c66863255.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():IsAbleToHand() end
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c66863255.thop(e,tp,eg,ep,ev,re,r,rp)
  local tc=e:GetHandler()
  if tc:IsRelateToEffect(e) then
	Duel.SendtoHand(tc,tp,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tc)
  end
end

function c66863255.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(511001225)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e1)
end
function c66863255.xyzchk(e,tp,eg,ep,ev,re,r,rp)
	Duel.CreateToken(1-tp,419)
end