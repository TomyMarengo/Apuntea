package ar.edu.itba.paw.persistence;

import ar.edu.itba.paw.models.*;
import ar.edu.itba.paw.models.search.SearchArguments;
import ar.edu.itba.paw.models.search.Searchable;
import ar.edu.itba.paw.models.search.SortArguments;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import javax.persistence.Query;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import java.math.BigInteger;
import java.util.*;

import static ar.edu.itba.paw.persistence.DaoUtils.*;
import static ar.edu.itba.paw.models.NameConstants.*;

@Repository
public class SearchJpaDao implements SearchDao {
    @PersistenceContext
    private EntityManager em;

    private final NoteDao noteDao;

    private final DirectoryDao directoryDao;

    @Autowired
    public SearchJpaDao(NoteDao noteDao, DirectoryDao directoryDao) {
        this.noteDao = noteDao;
        this.directoryDao = directoryDao;
    }

    private static final String WORD_CONDITION = "AND LOWER(t.name) LIKE LOWER(:name) ESCAPE '!' ";

    @Override
    public List<Searchable> search(SearchArguments sa) {
        SortArguments sortArgs = sa.getSortArguments();

        QueryCreator queryCreator = new QueryCreator("SELECT DISTINCT CAST(id as VARCHAR(36)), (category != 'DIRECTORY') as isNote, ")
                .append(DaoUtils.SORTBY.getOrDefault(sortArgs.getSortBy(), NAME))
                .append(" FROM Search t WHERE TRUE ");

        applyInstitutionFilters(queryCreator, sa);
        return getSearchResults(queryCreator, sa);
    }

    private List<Searchable> getSearchResults(QueryCreator queryCreator, SearchArguments sa){
        SortArguments sortArgs = sa.getSortArguments();
        applyGeneralFilters(queryCreator, sa);

        queryCreator.append("ORDER BY isNote ASC, ").append(DaoUtils.SORTBY.getOrDefault(sortArgs.getSortBy(), NAME)).append(sortArgs.isAscending() ? "" : " DESC ");

        Query query = em.createNativeQuery(queryCreator.createQuery())
                .setFirstResult(sa.getPageSize() * (sa.getPage() - 1))
                .setMaxResults(sa.getPageSize());

        queryCreator.getParams().forEach(query::setParameter);

        List<UUID> noteIds = new ArrayList<>();
        List<UUID> directoryIds = new ArrayList<>();

        @SuppressWarnings("unchecked")
        List<Object[]> resultList = query.getResultList();
        for (Object[] result : resultList) {
            if (result[1].equals(Boolean.TRUE))
                noteIds.add(UUID.fromString((String) result[0]));
            else
                directoryIds.add(UUID.fromString((String) result[0]));
        }

        List<Searchable> searchables = new ArrayList<>();
        if (!directoryIds.isEmpty()){
            searchables.addAll(directoryDao.findDirectoriesByIds(directoryIds, sortArgs));
            sa.getCurrentUserId().ifPresent(uId -> directoryDao.loadDirectoryFavorites(directoryIds, uId));
        }
        if (!noteIds.isEmpty()) {
            searchables.addAll(noteDao.findNotesByIds(noteIds, sa.getCurrentUserId().orElse(null), sortArgs));
            sa.getCurrentUserId().ifPresent(uId -> noteDao.loadNoteFavorites(noteIds, uId));
        }

       return searchables;
    }

    @Override
    public int countSearchResults(SearchArguments sa) {
        QueryCreator queryCreator = new QueryCreator("SELECT COUNT(DISTINCT t.id) FROM Search t WHERE TRUE ");

        applyInstitutionFilters(queryCreator, sa);
        applyGeneralFilters(queryCreator, sa);

        Query query = em.createNativeQuery(queryCreator.createQuery());
        queryCreator.getParams().forEach(query::setParameter);

        return ((BigInteger)query.getSingleResult()).intValue();
    }

    @Override
    public List<Searchable> getNavigationResults(SearchArguments sa, UUID parentId) {
        SortArguments sortArgs = sa.getSortArguments();

        QueryCreator queryCreator = new QueryCreator("SELECT DISTINCT CAST(id as VARCHAR(36)), (category != 'DIRECTORY') as isNote, ")
                .append(DaoUtils.SORTBY.getOrDefault(sortArgs.getSortBy(), NAME))
                .append(" FROM Navigation t WHERE t.parent_id = :parentId ");
        queryCreator.addParameter("parentId", parentId);

        return getSearchResults(queryCreator, sa);
    }

    @Override
    public int countNavigationResults(SearchArguments sa, UUID parentId){
        QueryCreator queryCreator = new QueryCreator("SELECT COUNT(DISTINCT t.id) FROM Navigation t WHERE t.parent_id = :parentId ");
        queryCreator.addParameter("parentId", parentId);

        applyGeneralFilters(queryCreator, sa);

        Query query = em.createNativeQuery(queryCreator.createQuery());
        queryCreator.getParams().forEach(query::setParameter);

        return ((BigInteger)query.getSingleResult()).intValue();
    }

    @Override
    public Optional<UUID> findByName(UUID parentId, String name, UUID currentUserId) {
        return (em.createNativeQuery("SELECT CAST(n.id AS VARCHAR(36)) FROM Navigation n WHERE n.name = :name AND n.parent_id = :parentId AND n.user_id = :currentUserId")
                .setParameter("name", name)
                .setParameter("parentId", parentId)
                .setParameter("currentUserId", currentUserId)
                .getResultList()
                .stream()
                .findFirst()).map(o -> UUID.fromString((String) o));
    }

    @Override
    public int countChildren(UUID parentId) {
        return ((BigInteger)em.createNativeQuery("SELECT COUNT(*) FROM Navigation WHERE parent_id = :parentId")
                .setParameter("parentId", parentId)
                .getSingleResult()).intValue();
    }

    private void applyInstitutionFilters(QueryCreator queryCreator, SearchArguments sa) {
        queryCreator.addConditionIfPresent(INSTITUTION_ID, "=", "AND", sa.getInstitutionId());
        queryCreator.addConditionIfPresent(CAREER_ID, "=", "AND", sa.getCareerId());
        queryCreator.addConditionIfPresent(SUBJECT_ID, "=", "AND", sa.getSubjectId());
    }

    private void applyGeneralFilters(QueryCreator queryCreator, SearchArguments sa) {
        sa.getCategory().ifPresent(c -> {
            if (c == Category.NOTE) {
                queryCreator.addConditionIfPresent(CATEGORY, "!=", "AND", Optional.of(Category.DIRECTORY.toString()));
            } else {
                queryCreator.addConditionIfPresent(CATEGORY, "=", "AND", sa.getCategory().map(Enum::toString));
            }
        });

        queryCreator.addConditionIfPresent(USER_ID, "=", "AND", sa.getUserId());

        sa.getWord().ifPresent(w -> {
                    String searchWord = escapeLikeString(w);
                    queryCreator.append(WORD_CONDITION);
                    queryCreator.addParameter(NAME, searchWord);
                }
        );

        if (sa.getCurrentUserId().isPresent()) {
            queryCreator.append("AND (t.visible OR t.user_id = :currentUserId) ");
            queryCreator.addParameter(CURRENT_USER_ID, sa.getCurrentUserId().get());
        } else {
            queryCreator.append("AND t.visible ");
        }
    }

}
