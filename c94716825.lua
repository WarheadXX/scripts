--Treasure Room of the Guardians
function c94716825.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c94716825.target)
	e1:SetOperation(c94716825.activate)
	c:RegisterEffect(e1)
	--Equip 
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(94716825,9))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c94716825.eqcon)
	e2:SetTarget(c94716825.eqtg)
	e2:SetOperation(c94716825.eqop)
	c:RegisterEffect(e2)
	--Unaffected
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_ONFIELD,0)
	e3:SetCondition(c94716825.uncon)
	e3:SetTarget(c94716825.untg)
	e3:SetValue(c94716825.unval)
	c:RegisterEffect(e3)
	--draw
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(94716825,10))
	e4:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCountLimit(1)
	e4:SetTarget(c94716825.drtg)
	e4:SetOperation(c94716825.drop)
	c:RegisterEffect(e4)
	--tofield
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(94716825,11))
	e5:SetCategory(CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetCountLimit(1,94716825+EFFECT_COUNT_CODE_DUEL)
	e5:SetCondition(c94716825.setcon)
	e5:SetTarget(c94716825.settg)
	e5:SetOperation(c94716825.setop)
	c:RegisterEffect(e5)
	--shuffle back
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DAMAGE)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_TO_GRAVE)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e6:SetTarget(c94716825.shtg)
	e6:SetOperation(c94716825.shpop)
	c:RegisterEffect(e6)
	-- Change Code
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(94716825,1))
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetRange(LOCATION_SZONE)
	e7:SetCountLimit(1)
	e7:SetTarget(c94716825.nmtg)
	e7:SetOperation(c94716825.nmop)
	c:RegisterEffect(e7)
end
c94716825.gn={aux.Stringid(94716825,2),aux.Stringid(94716825,3),aux.Stringid(94716825,4),aux.Stringid(94716825,5),aux.Stringid(94716825,6),aux.Stringid(94716825,7),aux.Stringid(94716825,8)}
c94716825.gc={32022366,95515060,95638658,68427465,21900719,69243953,81954378}

function c94716825.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c94716825.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	local g=Duel.GetMatchingGroup(c94716825.tgfilter,tp,LOCATION_DECK,0,nil)
	local ct=g:GetClassCount(Card.GetCode)
	return ct>6
end
function c94716825.tgfilter(c)
	return c:IsCode(32022366) or c:IsCode(95515060) or c:IsCode(95638658) or c:IsCode(68427465) or c:IsCode(21900719)
	or c:IsCode(69243953) or c:IsCode(81954378) or c:IsCode(59546390)
end
function c94716825.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c94716825.tgfilter,tp,LOCATION_DECK,0,1,7,nil)
	Duel.SendtoGrave(g,REASON_COST)
end

function c94716825.eqcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	if Duel.GetTurnPlayer()==tp then
		return ph==PHASE_MAIN1 or ph==PHASE_MAIN2 or ph==PHASE_BATTLE
end
end
function c94716825.tcfilter(c)
	return c:IsFaceup() 
end
function c94716825.ecfilter(c,ec)
	return c:IsType(TYPE_EQUIP) and Duel.IsExistingTarget(c94716825.tcfilter,0,LOCATION_MZONE,LOCATION_MZONE,1,nil,c) and c:CheckEquipTarget(c) or c:IsCode(81954378)
end
function c94716825.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c94716825.ecfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e:GetHandler()) and 
		Duel.IsExistingTarget(c94716825.tcfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)end
		tc=Duel.SelectTarget(tp,c94716825.tcfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_DECK)
end
function c94716825.eqop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or tc:IsFacedown() or not tc:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(18175965,3))
	local g=Duel.SelectMatchingCard(tp,c94716825.ecfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,c)
	if g:GetCount()>0 then
		Duel.Equip(tp,g:GetFirst(),tc)
end
end

function c94716825.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(82) and c:IsType(TYPE_MONSTER)
end
function c94716825.uncon(e,tp,eg,ep,ev,re,r,rp)
if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c94716825.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c94716825.untg(e,c)
	return c:IsType(TYPE_SPELL) and c:IsFaceup()
end
function c94716825.unval(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end

function c94716825.drfilter(c)
	return c:GetType()==TYPE_SPELL+TYPE_EQUIP and c:IsAbleToDeck()
end
function c94716825.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp)
		and Duel.IsExistingMatchingCard(c94716825.drfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
end
function c94716825.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(p,c94716825.drfilter,p,LOCATION_HAND,0,1,63,nil)
	if g:GetCount()>0 then
		Duel.ConfirmCards(1-p,g)
		local ct=Duel.SendtoDeck(g,nil,1,REASON_EFFECT)
		Duel.BreakEffect()
		Duel.Draw(p,ct,REASON_EFFECT)
	end
end

function c94716825.sfilter(c)
	return c:IsFaceup() and c:IsCode(17052477)
end
function c94716825.setcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c94716825.sfilter,tp,LOCATION_SZONE,0,1,nil)
end
function c94716825.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c94716825.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsSSetable() then
		Duel.SSet(tp,c)
		Duel.ConfirmCards(1-tp,c)
	end
end

function c94716825.tdfilter(c)
	return  c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function c94716825.shtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c94716825.tdfilter,tp,LOCATION_GRAVE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c94716825.shpop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c94716825.tdfilter,tp,LOCATION_GRAVE,0,nil)
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,nil,1,REASON_EFFECT)
	end
end

function c94716825.nmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local opt=Duel.SelectOption(tp,c94716825.gn[1],c94716825.gn[2],c94716825.gn[3],c94716825.gn[4],c94716825.gn[5],c94716825.gn[6],c94716825.gn[7])+1
	local nm=c94716825.gc[opt]
	e:SetLabel(nm)
	Duel.SetTargetParam(nm)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,ANNOUNCE_CARD)
end
function c94716825.nmop(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_SZONE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(ac)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
	end
end