function map = mrfMap(mrf, varargin)
%% Find the mode, (map assignment)
% Optional named args are the same as for mrfInferNodes
[clamped, softEv, localEv] = process_options(varargin, ...
    'clamped', [], ...
    'softev' , [], ...
    'localev', []);
localFacs = {};
if ~isempty(localEv)
    localFacs = softEvToFactors(localEvToSoftEv(mrf, localEv));
end
if ~isempty(softEv)
    localFacs = [localFacs(:); colvec(softEvToFactors(softEv))];
end
fg = mrf.cliqueGraph; 
if isfield(mrf, 'jtree')
    jtree     = jtreeSliceCliques(mrf.jtree, clamped);
else
    doSlice   = true;
    fg.Tfac   = addEvidenceToFactors(fg.Tfac, clamped, doSlice);
    fg.nstates(find(clamped)) = 1; %#ok
    jtree     = jtreeCreate(fg);
end
jtree         = jtreeAddFactors(jtree, localFacs);
map           = jtreeFindMap(jtree); 
if ~isempty(clamped)
    map(find(clamped)) = nonzeros(clamped); %#ok 
end
end