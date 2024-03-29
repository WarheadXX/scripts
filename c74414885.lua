--NEXT
--Neospace Extension
--Scripted by AlphaKretin
function c74414885.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,74414885+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c74414885.sptg)
	e1:SetOperation(c74414885.spop)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c74414885.handcon)
	c:RegisterEffect(e2)
end
c74414885.listed_names={ 89943723 }
-- c74414885.listed_names={89943723}
function c74414885.filter(c,e,tp)
	return (c:IsSetCard(0x1f) or c:IsCode(89943723)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c74414885.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c74414885.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c74414885.rescon(sg,e,tp,mg)
	return aux.ChkfMMZ(sg) and sg:GetClassCount(Card.GetCode)==sg
end
function c74414885.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	if ft>5 then ft=5 end
	local sg=Duel.GetMatchingGroup(aux.NecroValleyFilter(c74414885.filter),tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp)
	local ng=Duel.GetMatchingGroupCount(aux.NecroValleyFilter(c74414885.filter),tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp)
	-- local ng=Duel.GetMatchingGroup(aux.NecroValleyFilter(c74414885.filter),tp,LOCATION_HAND+LOCATION_GRAVE,0,nil)
	-- local g=Duel.SelectMatchingCard(sg,e,tp,1,ft,c74414885.rescon,1,tp,HINTMSG_SPSUMMON)
	-- local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c74414885.filter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,ft,nil,e,tp)
	local g=Group.CreateGroup()
	for i=1,ft do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local tc=sg:Select(tp,1,1,nil):GetFirst()
		if tc then
			g:AddCard(tc)
			sg:Remove(Card.IsCode,nil,tc:GetCode())
		end
	end
	if g:GetCount()>0 then
		for tc in aux.Next(g) do
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1,true)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2,true)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_FIELD)
			e3:SetRange(LOCATION_MZONE)
			e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
			e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e3:SetAbsoluteRange(tp,1,0)
			e3:SetTarget(c74414885.splimit)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e3,true)
		end
	end
end
function c74414885.splimit(e,c)
	return c:IsLocation(LOCATION_EXTRA) and not c:IsType(TYPE_FUSION)
end
function c74414885.handcon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_ONFIELD,0)==0
end

