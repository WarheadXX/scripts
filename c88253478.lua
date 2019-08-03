--Gravekeeper's Assistant
function c88253478.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c88253478.spcon)
	c:RegisterEffect(e1)
	--Draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(88253478,0))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c88253478.cost)
	e2:SetTarget(c88253478.target)
	e2:SetOperation(c88253478.operation)
	c:RegisterEffect(e2)
	--ATK INCREASE
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetCondition(c88253478.con)
	e3:SetTarget(c88253478.tg)
	e3:SetValue(500)
	c:RegisterEffect(e3)
	--position change
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(88253478,1))
	e4:SetCategory(CATEGORY_POSITION+CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCountLimit(1)
	e4:SetTarget(c88253478.postg)
	e4:SetOperation(c88253478.posop)
	c:RegisterEffect(e4)
	--destroy replace
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_DESTROY_REPLACE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTarget(c88253478.destg)
	e5:SetValue(c88253478.repval)
	c:RegisterEffect(e5)
end

function c88253478.cfilter(c)
	return c:IsSetCard(46) and c:IsLevelAbove(5)
end
function c88253478.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c88253478.cfilter,tp,LOCATION_ONFIELD,0,1,nil) and 
	Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end

function c88253478.costfilter(c)
	return c:IsSetCard(46) 
end
function c88253478.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c88253478.costfilter,1,e:GetHandler()) end
	local sg=Duel.SelectReleaseGroup(tp,c88253478.costfilter,1,1,e:GetHandler())
	Duel.Release(sg,REASON_COST)
end
function c88253478.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c88253478.operation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT) 
end

function c88253478.con(e)
	return e:GetHandler():IsSetCard(46)
end
function c88253478.tg(e,c)
	return c:IsSetCard(46)
end


function c88253478.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFacedown() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFacedown,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,Card.IsFacedown,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c88253478.posop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.ChangePosition(tc,POS_FACEUP_ATTACK)
		Duel.SetTargetPlayer(1-tp)
		Duel.SetTargetParam(1000)
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		if Duel.Damage(p,1000,d,REASON_EFFECT) then
	end
end
end

function c88253478.rfilter(c)
	return c:IsFaceup() and c:IsLocation(LOCATION_ONFIELD) and (c:IsSetCard(46) or c:IsCode(47355498)) and not c:IsCode(88253478)
end
function c88253478.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c88253478.rfilter,1,e:GetHandler()) end
	if Duel.SelectYesNo(tp,aux.Stringid(88253478,2)) then
		Duel.Destroy(e:GetHandler(),REASON_EFFECT+REASON_REPLACE)
		return true
	else return false end
end
function c88253478.repval(e,c)
	return c:IsFaceup() and (c:IsSetCard(46) or c:IsCode(47355498)) and not c:IsCode(88253478) and c~=e:GetHandler() 
end