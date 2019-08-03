--Meklord Dominance
function c60682160.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c60682160.target)
	e1:SetOperation(c60682160.activate)
	c:RegisterEffect(e1)
	--Add "Meklord" Spell/Trap from Deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(57933746,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCost(c60682160.thcost)
	e2:SetTarget(c60682160.thtg)
	e2:SetOperation(c60682160.thop)
	c:RegisterEffect(e2)
end

function c60682160.tcfilter(c,tc,ec)
	return c:IsFaceup() and c:IsSetCard(0x3013) or c:IsCode(63468625) or c:IsCode(38522377) 
end
function c60682160.eqfilter(c,g)
	return c:IsType(TYPE_SYNCHRO) and c:IsFaceup()
end
function c60682160.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c60682160.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c60682160.tcfilter,tp,LOCATION_MZONE,0,1,nil) 
	and Duel.IsExistingTarget(c60682160.eqfilter,tp,0,LOCATION_MZONE,1,nil)end
end
function c60682160.activate(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if ft<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(511000926,0))
	local g=Duel.SelectMatchingCard(tp,c60682160.eqfilter,tp,0,LOCATION_MZONE,1,ft,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(511000926,1))
	local tc=Duel.SelectMatchingCard(tp,c60682160.tcfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,ec,e,tp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local tc=tc:GetFirst()
	local ec=g:GetFirst()
	local atk=ec:GetTextAttack()
			while ec do
				Duel.Equip(tp,ec,tc,false,true)
				ec:RegisterFlagEffect(60682160,RESET_EVENT+0x1fe0000,0,0)
				local e1=Effect.CreateEffect(tc)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_EQUIP_LIMIT)
				e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
				e1:SetReset(RESET_EVENT+0x1fe0000)
				e1:SetValue(c60682160.eqlimit)
				ec:RegisterEffect(e1)
				local e2=Effect.CreateEffect(tc)
				e2:SetType(EFFECT_TYPE_EQUIP)
				e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_OWNER_RELATE)
				e2:SetCode(EFFECT_UPDATE_ATTACK)
				e2:SetReset(RESET_EVENT+0x1fe0000)
				e2:SetValue(atk)
				ec:RegisterEffect(e2)
				ec=g:GetNext()
							end
			Duel.EquipComplete()
end

function c60682160.eqlimit(e,c)
	return e:GetOwner()==c and not c:IsDisabled()
end

function c60682160.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c60682160.thfilter(c)
	return c:IsCode(4081825) or c:IsCode(41475424) or c:IsCode(77864539) or c:IsCode(95007306) or c:IsCode(63485578) 
	  or c:IsCode(12986778) or c:IsCode(50449979) or c:IsCode(85775486) or c:IsCode(60682160) or c:IsCode(59371387)
	  or c:IsCode(61561967) or c:IsCode(67328336) or c:IsCode(86997073) or c:IsCode(11681434) or c:IsCode(4803054)
	  or c:IsCode(32552314)
	  and c:IsType(TYPE_TRAP+TYPE_SPELL) and c:IsAbleToHand()
end
function c60682160.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60682160.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c60682160.desfilter(c)
	return c:IsOnField() and c:IsDestructable()
end
function c60682160.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c60682160.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		local g=Duel.GetMatchingGroup(c60682160.desfilter,tp,LOCATION_ONFIELD,0,e:GetHandler())
			if g:GetCount()>0 then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
				local sg=g:Select(tp,1,1,nil)
				Duel.Destroy(sg,REASON_EFFECT)
			end
		end
	end