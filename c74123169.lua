--Guardian's Treachery
function c74123169.initial_effect(c)
	--Activate Spell Card on either player's side of the field 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(74123169,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,74123169+EFFECT_COUNT_CODE_DUEL)
	e1:SetCondition(c74123169.condition)
	e1:SetTarget(c74123169.target)
	e1:SetOperation(c74123169.activate)
	c:RegisterEffect(e1)
	--Activate From Hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c74123169.handcon)
	c:RegisterEffect(e2)
	if not c74123169.global_check then
		c74123169.global_check=true
	--Activate From Grave
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(74123169,4))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,74123169+EFFECT_COUNT_CODE_DUEL)
	e3:SetCondition(c74123169.fgcon)
	e3:SetTarget(c74123169.fgtg)
	e3:SetOperation(c74123169.fgop)
	c:RegisterEffect(e3)
	--Activate From Deck
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(74123169,3))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_DECK)
	e4:SetCountLimit(1,74123169+EFFECT_COUNT_CODE_DUEL)
	e4:SetCost(c74123169.fgcost1)
	e4:SetCondition(c74123169.fgcon1)
	e4:SetTarget(c74123169.fgtg1)
	e4:SetOperation(c74123169.fgop1)
	c:RegisterEffect(e4)
	--ATK Increase and Field Nuke
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(74123169,2))
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e5:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCondition(c74123169.atkcon)
	e5:SetCost(c74123169.atkcost)
	e5:SetTarget(c74123169.atktg)
	e5:SetOperation(c74123169.atkop)
	c:RegisterEffect(e5)
end
end

function c74123169.handcon(e)
	return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE,0)>0 and	Duel.IsExistingMatchingCard(c74123169.cfilter,tp,LOCATION_MZONE,0,2,nil)
end
function c74123169.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(82)
end
function c74123169.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(Card.IsType,e:GetHandlerPlayer(),LOCATION_GRAVE,0,1,nil,TYPE_MONSTER)
end
function c74123169.filter(c,tp)
	return c:IsType(TYPE_FIELD) and c:GetActivateEffect():IsActivatable(tp)
end
function c74123169.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c74123169.filter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND,0,1,nil,tp) end
end
function c74123169.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetMatchingGroup(c74123169.filter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND,1,nil,tp,eg,ep,ev,re,r,rp)
	if tc:GetCount()<=0 then return end
	local g=Duel.SelectMatchingCard(tp,c74123169.filter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,tp)
		local tc=g:GetFirst()
        local tpe=tc:GetType()
		local te=tc:GetActivateEffect()
		local opt=0
		if te then
    	    local con=te:GetCondition()
			local co=te:GetCost()
			local tg=te:GetTarget()
			local op1=te:GetOperation()
			Duel.ClearTargetCard()
			e:SetCategory(te:GetCategory())
			e:SetProperty(te:GetProperty())
			if bit.band(tpe,TYPE_FIELD)==0 then
				local of=Duel.GetFieldCard(tp,LOCATION_SZONE,5)>0
				local of=Duel.GetFieldCard(1-tp,LOCATION_SZONE,5)>0
				if of and Duel.Destroy(of,REASON_RULE)==0 then Duel.SendtoGrave(tc,REASON_RULE) end
			end
			local s1=Duel.GetLocationCount(tp,LOCATION_SZONE,7)
			local s2=Duel.GetLocationCount(1-tp,LOCATION_SZONE,7)
			if s1 and s2 then op=Duel.SelectOption(tp,aux.Stringid(74123169,5),aux.Stringid(74123169,6))
			elseif s1 then op=Duel.SelectOption(tp,aux.Stringid(74123169,5))
			elseif s2 then op=Duel.SelectOption(tp,aux.Stringid(74123169,6))+1 end
			if op==0 then Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) 
			Duel.Hint(HINT_CARD,0,tc:GetCode())
			tc:CreateEffectRelation(te)
			elseif op==1 then Duel.MoveToField(tc,1-tp,1-tp,LOCATION_SZONE,POS_FACEUP,true)
			Duel.Hint(HINT_CARD,0,tc:GetCode())
			tc:CreateEffectRelation(te)
			end
			if co then co(te,tp,eg,ep,ev,re,r,rp,1) end
			if tg then tg(te,tp,eg,ep,ev,re,r,rp,1) end
			local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
			if g then
				local etc=g:GetFirst()
				while etc do
					etc:CreateEffectRelation(te)
					etc=g:GetNext()
				end
			end
			if op==0 and op1 then op1(te,tp,eg,ep,ev,re,r,rp)
			elseif op==1 and op1 then op1(te,1-tp,eg,ep,ev,re,r,rp)
			tc:ReleaseEffectRelation(te)
			if etc then	
				etc=g:GetFirst()
				while etc do
					etc:ReleaseEffectRelation(te)
					etc=g:GetNext()
				end
			end
		end
	end
	end

function c74123169.fgcfilter(c)
	return c:IsFaceup() and c:IsSetCard(82)
end
function c74123169.fgcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and	Duel.IsExistingMatchingCard(c74123169.fgcfilter,tp,LOCATION_MZONE,0,2,nil)
		and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0
		and not Duel.IsExistingMatchingCard(Card.IsType,e:GetHandlerPlayer(),LOCATION_GRAVE,0,1,nil,TYPE_MONSTER)
end
function c74123169.fgfilter(c)
	return c:IsType(TYPE_FIELD)
end
function c74123169.fgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c74123169.filter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND,0,1,nil,tp) end
end
function c74123169.fgop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetMatchingGroup(c74123169.filter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND,1,nil,tp,eg,ep,ev,re,r,rp)
	if tc:GetCount()<=0 then return end
	local g=Duel.SelectMatchingCard(tp,c74123169.filter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,tp)
		local tc=g:GetFirst()
        local tpe=tc:GetType()
		local te=tc:GetActivateEffect()
		local opt=0
		if te then
    	    local con=te:GetCondition()
			local co=te:GetCost()
			local tg=te:GetTarget()
			local op1=te:GetOperation()
			Duel.ClearTargetCard()
			e:SetCategory(te:GetCategory())
			e:SetProperty(te:GetProperty())
			if bit.band(tpe,TYPE_FIELD)==0 then
				local of=Duel.GetFieldCard(tp,LOCATION_SZONE,5)>0
				local of=Duel.GetFieldCard(1-tp,LOCATION_SZONE,5)>0
				if of and Duel.Destroy(of,REASON_RULE)==0 then Duel.SendtoGrave(tc,REASON_RULE) end
			end
			local s1=Duel.GetLocationCount(tp,LOCATION_SZONE,5)
			local s2=Duel.GetLocationCount(1-tp,LOCATION_SZONE,5)
			if s1 and s2 then op=Duel.SelectOption(tp,aux.Stringid(74123169,5),aux.Stringid(74123169,6))
			elseif s1 then op=Duel.SelectOption(tp,aux.Stringid(74123169,5))
			elseif s2 then op=Duel.SelectOption(tp,aux.Stringid(74123169,6))+1 end
			if op==0 then Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) 
			Duel.Hint(HINT_CARD,0,tc:GetCode())
			tc:CreateEffectRelation(te)
			elseif op==1 then Duel.MoveToField(tc,1-tp,1-tp,LOCATION_SZONE,POS_FACEUP,true)
			Duel.Hint(HINT_CARD,0,tc:GetCode())
			tc:CreateEffectRelation(te)
			end
			if co then co(te,tp,eg,ep,ev,re,r,rp,1) end
			if tg then tg(te,tp,eg,ep,ev,re,r,rp,1) end
			local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
			if g then
				local etc=g:GetFirst()
				while etc do
					etc:CreateEffectRelation(te)
					etc=g:GetNext()
				end
			end
			if op==0 and op1 then op1(te,tp,eg,ep,ev,re,r,rp)
			elseif op==1 and op1 then op1(te,1-tp,eg,ep,ev,re,r,rp)
			tc:ReleaseEffectRelation(te)
			if etc then	
				etc=g:GetFirst()
				while etc do
					etc:ReleaseEffectRelation(te)
					etc=g:GetNext()
				end
			end
		end
	end
	end

function c74123169.fgcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c74123169.fgcfilter1(c)
	return c:IsFaceup() and c:IsSetCard(82)
end
function c74123169.fgcon1(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and	Duel.IsExistingMatchingCard(c74123169.fgcfilter1,tp,LOCATION_MZONE,0,2,nil)
		and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0
		and not Duel.IsExistingMatchingCard(Card.IsType,e:GetHandlerPlayer(),LOCATION_GRAVE,0,1,nil,TYPE_MONSTER)
end
function c74123169.fgfilter1(c)
	return c:IsType(TYPE_FIELD)
end
function c74123169.fgtg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c74123169.fgfilter1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND,0,1,nil,tp) end
end
function c74123169.fgop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetMatchingGroup(c74123169.filter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND,1,nil,tp,eg,ep,ev,re,r,rp)
	if tc:GetCount()<=0 then return end
	local g=Duel.SelectMatchingCard(tp,c74123169.filter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,tp)
		local tc=g:GetFirst()
        local tpe=tc:GetType()
		local te=tc:GetActivateEffect()
		local opt=0
		if te then
    	    local con=te:GetCondition()
			local co=te:GetCost()
			local tg=te:GetTarget()
			local op1=te:GetOperation()
			Duel.ClearTargetCard()
			e:SetCategory(te:GetCategory())
			e:SetProperty(te:GetProperty())
			if bit.band(tpe,TYPE_FIELD)==0 then
				local of1=Duel.GetFieldCard(tp,LOCATION_SZONE,5)>0
				local of2=Duel.GetFieldCard(1-tp,LOCATION_SZONE,5)>0
				if of1 and Duel.Destroy(of1,REASON_RULE)==0 then Duel.SendtoGrave(tc,REASON_RULE) end
				if of2 and Duel.Destroy(of2,REASON_RULE)==0 then Duel.SendtoGrave(tc,REASON_RULE) end
			end
			local s1=Duel.GetLocationCount(tp,LOCATION_SZONE,5)
			local s2=Duel.GetLocationCount(1-tp,LOCATION_SZONE,5)
			if s1 and s2 then op=Duel.SelectOption(tp,aux.Stringid(74123169,5),aux.Stringid(74123169,6))
			elseif s1 then op=Duel.SelectOption(tp,aux.Stringid(74123169,5))
			elseif s2 then op=Duel.SelectOption(tp,aux.Stringid(74123169,6))+1 end
			if op==0 then Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) 
			Duel.Hint(HINT_CARD,0,tc:GetCode())
			tc:CreateEffectRelation(te)
			elseif op==1 then Duel.MoveToField(tc,1-tp,1-tp,LOCATION_SZONE,POS_FACEUP,true)
			Duel.Hint(HINT_CARD,0,tc:GetCode())
			tc:CreateEffectRelation(te)
			end
			if co then co(te,tp,eg,ep,ev,re,r,rp,1) end
			if tg then tg(te,tp,eg,ep,ev,re,r,rp,1) end
			local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
			if g then
				local etc=g:GetFirst()
				while etc do
					etc:CreateEffectRelation(te)
					etc=g:GetNext()
				end
			end
			if op==0 and op1 then op1(te,tp,eg,ep,ev,re,r,rp)
			elseif op==1 and op1 then op1(te,1-tp,eg,ep,ev,re,r,rp)
			tc:ReleaseEffectRelation(te)
			if etc then	
				etc=g:GetFirst()
				while etc do
					etc:ReleaseEffectRelation(te)
					etc=g:GetNext()
				end
			end
		end
	end
	end

function c74123169.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c74123169.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c74123169.atkfilter(c)
	return c:IsFaceup() and c:IsCode(18175965)
end
function c74123169.atkfilter2(c)
	return c:IsType(TYPE_MONSTER)
end
function c74123169.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c74123169.atkfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c74123169.atkfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c74123169.atkfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c74123169.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local g=Duel.GetMatchingGroup(c74123169.atkfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,tc)
	local sum=0
		Duel.SendtoGrave(g,REASON_EFFECT)
	local sum=Duel.GetOperatedGroup():GetSum(Card.GetAttack)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e1:SetValue(sum)
	tc:RegisterEffect(e1)
end

