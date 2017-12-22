package architecture.community.codeset.dao;

import java.util.List;

import architecture.community.codeset.CodeSet;
import architecture.community.model.ModelObjectTreeWalker;

public interface CodeSetDao {
	
	public void batchInsertCodeSet(List<CodeSet> codesets);

    public void saveOrUpdateCodeSet(List<CodeSet> codesets);

    public void saveOrUpdateCodeSet(CodeSet codeset);

    public CodeSet getCodeSetById(long codesetId);    
    
    public int getCodeSetCount(int objectType, long objectId);

    public List<Long> getCodeSetIds(int objectType, long objectId);
    

    public int getCodeSetCount(int objectType, long objectId, Long parentCodeSetId);

    public List<Long> getCodeSetIds(int objectType, long objectId, Long parentCodeSetId);

    
    public ModelObjectTreeWalker getTreeWalker(int objectType, long objectId);

    public int getCodeSetCount(int objectType, long objectId, String groupCode);
    
    public List<Long> getCodeSetIds(int objectType, long objectId, String groupCode);
    
}
