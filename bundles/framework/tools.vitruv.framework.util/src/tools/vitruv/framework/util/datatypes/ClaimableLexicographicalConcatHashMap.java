package tools.vitruv.framework.util.datatypes;

import java.util.Arrays;

public class ClaimableLexicographicalConcatHashMap<K, V> extends ClaimableConcatHashMap<K, V, String> {

    @SuppressWarnings("unchecked")
	@Override
    public String getConcatenatedKey(final K... keys) {
        if (keys.length > 0) {
            Arrays.sort(keys);
            StringBuffer concatenatedKeyBuffer = new StringBuffer();
            for (K pivot : keys) {
                concatenatedKeyBuffer.append(pivot);
            }
            return concatenatedKeyBuffer.toString();
        } else {
            throw new IllegalArgumentException("At least one key required!");
        }
    }

    @Override
    public boolean isPartOf(final K partialKey, final String fullKey) {
        return fullKey.contains(partialKey.toString());
    }

}
