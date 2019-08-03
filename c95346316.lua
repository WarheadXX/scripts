--Guardian Formation
function c95346316.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_BE_BATTLE_TARGET)
	e1:SetCondition(c95346316.condition)
	e1:SetTarget(c95346316.target)
	e1:SetOperation(c95346316.activate)
	c:RegisterEffect(e1)
end
function c95346316.condition(e,tp,eg,ep,ev,re,r,rp)
	local d=Duel.GetAttackTarget()
	return d:IsControler(tp) and d:IsFaceup() and d:IsSetCard(82) 
end
function c95346316.filter(c,e,tp,eg,ep,ev,re,r,rp)
	local te=c:GetActivateEffect()
	if not te then return false end
	local target=te:GetTarget()
	return c:IsType(TYPE_SPELL)
		and (not target or target(te,tp,eg,ep,ev,re,r,rp,0)) and (c:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0)
end
function c95346316.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local td=Duel.GetAttackTarget()
	if chk==0 then return td:IsOnField() end
	Duel.SetTargetCard(td)
end
function c95346316.activate(e,tp,eg,ep,ev,re,r,rp)
	local td=Duel.GetAttackTarget()
	if td and Duel.NegateAttack() and td:IsFaceup() and td:IsRelateToEffect(e) then
		Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE,1)
		local acg=Duel.GetMatchingGroup(c95346316.filter,tp,LOCATION_DECK+LOCATION_HAND,0,nil,e,tp,eg,ep,ev,re,r,rp)
		if acg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(28265983,0)) then
			local tc=acg:Select(tp,1,1,nil):GetFirst()
			local tpe=tc:GetType()
			local te=tc:GetActivateEffect()
			local tg=te:GetTarget()
			local op=te:GetOperation()
			e:SetCategory(te:GetCategory())
			e:SetProperty(te:GetProperty())
			Duel.ClearTargetCard()
			if bit.band(tpe,TYPE_FIELD)~=0 then
				local of=Duel.GetFieldCard(1-tp,LOCATION_SZONE,5)
				if of then Duel.Destroy(of,REASON_RULE) end
				of=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
				if of and Duel.Destroy(of,REASON_RULE)==0 then Duel.SendtoGrave(tc,REASON_RULE) end
			end
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			Duel.Hint(HINT_CARD,0,tc:GetCode())
			tc:CreateEffectRelation(te)
			if bit.band(tpe,TYPE_EQUIP+TYPE_CONTINUOUS+TYPE_FIELD)==0 then
				tc:CancelToGrave(false)
			end
			if tg then tg(te,tp,eg,ep,ev,re,r,rp,1) end
			Duel.BreakEffect()
			local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
			if g then
				local etc=g:GetFirst()
				while etc do
					etc:CreateEffectRelation(te)
					etc=g:GetNext()
				end
			end
			if op then op(te,tp,eg,ep,ev,re,r,rp) end
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
