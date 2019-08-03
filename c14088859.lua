--ネオス・フュージョン
--Neos Fusion
--Scripted by Eerie Code
function c14088859.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c14088859.target)
	e1:SetOperation(c14088859.activate)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(c14088859.reptg)
	e2:SetValue(c14088859.repval)
	e2:SetOperation(c14088859.repop)
	c:RegisterEffect(e2)
	if not AshBlossomTable then AshBlossomTable={} end
	table.insert(AshBlossomTable,e1)
end
c14088859.listed_names={89943723}
function c14088859.filter0(c)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToGrave()
end
function c14088859.filter1(c,e)
	return not c:IsImmuneToEffect(e)
end
function c14088859.filter2(c,e,tp,m,chkf)
	return aux.IsMaterialListCode(c,89943723)
		and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and c:CheckFusionMaterial(m,nil,tp) and TwoMaterialNeosCodes(c)
end
function TwoMaterialNeosCodes(c)
    return (c:IsCode(86346643) or c:IsCode(5128859) or c:IsCode(11502550) or c:IsCode(28677304) or c:IsCode(55171412) or c:IsCode(64655485) or c:IsCode(81566151) or c:IsCode(85507811) or c:IsCode(72926163) 
	or c:IsCode(48996569))
end
function c14088859.TwoMaterialfilter(c)
	return (c:IsCode(86346643) or c:IsCode(5128859) or c:IsCode(11502550) or c:IsCode(28677304) or c:IsCode(55171412) or c:IsCode(64655485) or c:IsCode(81566151) or c:IsCode(85507811) or c:IsCode(72926163))
end
function c14088859.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		Auxiliary.FCheckExact=2
		local mg1=Duel.GetFusionMaterial(tp)
		local mg2=Duel.GetMatchingGroup(c14088859.filter0,tp,LOCATION_DECK,0,nil)
		mg1:Merge(mg2)
		local res=Duel.IsExistingMatchingCard(c14088859.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,chkf)
		Auxiliary.FCheckExact=nil
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c14088859.activate(e,tp,eg,ep,ev,re,r,rp)
	local mg1=Duel.GetFusionMaterial(tp):Filter(c14088859.filter1,nil,e)
	local mg2=Duel.GetMatchingGroup(c14088859.filter0,tp,LOCATION_DECK,0,nil)
	mg1:Merge(mg2)
	Auxiliary.FCheckExact=2
	local sg1=Duel.GetMatchingGroup(c14088859.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil)
	if sg1:GetCount()>0 then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,tp)
		tc:SetMaterial(mat1)
		Duel.SendtoGrave(mat1,REASON_EFFECT)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
		tc:CompleteProcedure()
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Auxiliary.FCheckExact=nil
end
function NeosFusionMonsters(c)
   return (c:IsCode(86346643) or c:IsCode(5128859) or c:IsCode(11502550) or c:IsCode(28677304) or c:IsCode(55171412) or c:IsCode(64655485) or c:IsCode(81566151) or c:IsCode(85507811) or c:IsCode(72926163) 
	or c:IsCode(48996569) or c:IsCode(31111109) or c:IsCode(90050480) or c:IsCode(17032740) or c:IsCode(40080312) or c:IsCode(78512663) or c:IsCode(49352945))
end
function c14088859.repfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) 
		and c:IsType(TYPE_FUSION) and (aux.IsMaterialListCode(c,89943723) or NeosFusionMonsters(c))
		and not c:IsReason(REASON_REPLACE) and c:IsReason(REASON_EFFECT+REASON_BATTLE)
		-- and c:IsReason(REASON_EFFECT+REASON_BATTLE)
end
function c14088859.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c14088859.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c14088859.repval(e,c)
	return c14088859.repfilter(c,e:GetHandlerPlayer())
end
function c14088859.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end

