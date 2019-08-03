--Synchro Rebirth
function c68960854.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetLabel(0)
	e1:SetCost(c68960854.cost)
	e1:SetOperation(c68960854.activate)
	c:RegisterEffect(e1)
	--From Grave, Actual Rebirth
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(aux.exccon)
	e2:SetCost(c68960854.spcost)
	e2:SetTarget(c68960854.sptg)
	e2:SetOperation(c68960854.spop)
	c:RegisterEffect(e2)
end

function c68960854.cgfilter(c,lv)
	return c:IsAbleToRemoveAsCost()
end
function c68960854.tfilter(c,lv)
	return c:IsType(TYPE_SYNCHRO) and c:IsLevelBelow(lv)
end
function c68960854.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:SetLabel(0)
	local cg=Duel.GetMatchingGroup(c68960854.cgfilter,tp,LOCATION_GRAVE,0,nil)
	local tg=Duel.GetMatchingGroup(c68960854.tfilter,tp,LOCATION_EXTRA,0,nil,cg:GetCount())
	if tg:GetCount()>0 then
		local lvt={}
		local tc=tg:GetFirst()
		while tc do
			local tlv=tc:GetLevel()
			lvt[tlv]=tlv
			tc=tg:GetNext()
		end
		local pc=1
		for i=1,12 do
			if lvt[i] then lvt[i]=nil lvt[pc]=i pc=pc+1 end
		end
		lvt[pc]=nil
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(6733059,2))
		local lv=Duel.AnnounceNumber(tp,table.unpack(lvt))
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local rg=cg:Select(tp,lv,lv,nil)
		Duel.Remove(rg,POS_FACEDOWN,REASON_COST)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,tg,1,0,0)
		Duel.SetTargetParam(lv)
	end
end
function c68960854.filter2(c,lv)
	return c:IsType(TYPE_SYNCHRO) and c:GetLevel()==lv
end
function c68960854.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local lv=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	if lv==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c68960854.filter2,tp,LOCATION_EXTRA,0,1,1,nil,lv)
		Duel.SpecialSummon(g,SUMMON_TYPE_SYNCHRO,tp,tp,true,false,POS_FACEUP)
		g:GetFirst():CompleteProcedure()
end

function c68960854.spfilter(c,e)
	return c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c68960854.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c68960854.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
		if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c68960854.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c68960854.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.SelectMatchingCard(tp,c68960854.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		local tc=tc:GetFirst()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(1)
		tc:RegisterEffect(e1)
	end
end