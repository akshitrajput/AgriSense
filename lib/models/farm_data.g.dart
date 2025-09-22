// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'farm_data.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetFarmDataCollection on Isar {
  IsarCollection<FarmData> get farmDatas => this.collection();
}

const FarmDataSchema = CollectionSchema(
  name: r'FarmData',
  id: 1104917088053881237,
  properties: {
    r'cropTypeKey': PropertySchema(
      id: 0,
      name: r'cropTypeKey',
      type: IsarType.string,
    ),
    r'farmBreadth': PropertySchema(
      id: 1,
      name: r'farmBreadth',
      type: IsarType.double,
    ),
    r'farmLength': PropertySchema(
      id: 2,
      name: r'farmLength',
      type: IsarType.double,
    ),
    r'name': PropertySchema(
      id: 3,
      name: r'name',
      type: IsarType.string,
    ),
    r'plantsPerRow': PropertySchema(
      id: 4,
      name: r'plantsPerRow',
      type: IsarType.long,
    ),
    r'rows': PropertySchema(
      id: 5,
      name: r'rows',
      type: IsarType.long,
    )
  },
  estimateSize: _farmDataEstimateSize,
  serialize: _farmDataSerialize,
  deserialize: _farmDataDeserialize,
  deserializeProp: _farmDataDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _farmDataGetId,
  getLinks: _farmDataGetLinks,
  attach: _farmDataAttach,
  version: '3.1.0+1',
);

int _farmDataEstimateSize(
  FarmData object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.cropTypeKey;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.name;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _farmDataSerialize(
  FarmData object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.cropTypeKey);
  writer.writeDouble(offsets[1], object.farmBreadth);
  writer.writeDouble(offsets[2], object.farmLength);
  writer.writeString(offsets[3], object.name);
  writer.writeLong(offsets[4], object.plantsPerRow);
  writer.writeLong(offsets[5], object.rows);
}

FarmData _farmDataDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = FarmData(
    cropTypeKey: reader.readStringOrNull(offsets[0]),
    farmBreadth: reader.readDoubleOrNull(offsets[1]),
    farmLength: reader.readDoubleOrNull(offsets[2]),
    id: id,
    name: reader.readStringOrNull(offsets[3]),
    plantsPerRow: reader.readLongOrNull(offsets[4]),
    rows: reader.readLongOrNull(offsets[5]),
  );
  return object;
}

P _farmDataDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readDoubleOrNull(offset)) as P;
    case 2:
      return (reader.readDoubleOrNull(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readLongOrNull(offset)) as P;
    case 5:
      return (reader.readLongOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _farmDataGetId(FarmData object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _farmDataGetLinks(FarmData object) {
  return [];
}

void _farmDataAttach(IsarCollection<dynamic> col, Id id, FarmData object) {
  object.id = id;
}

extension FarmDataQueryWhereSort on QueryBuilder<FarmData, FarmData, QWhere> {
  QueryBuilder<FarmData, FarmData, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension FarmDataQueryWhere on QueryBuilder<FarmData, FarmData, QWhereClause> {
  QueryBuilder<FarmData, FarmData, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<FarmData, FarmData, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<FarmData, FarmData, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<FarmData, FarmData, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<FarmData, FarmData, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension FarmDataQueryFilter
    on QueryBuilder<FarmData, FarmData, QFilterCondition> {
  QueryBuilder<FarmData, FarmData, QAfterFilterCondition> cropTypeKeyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'cropTypeKey',
      ));
    });
  }

  QueryBuilder<FarmData, FarmData, QAfterFilterCondition>
      cropTypeKeyIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'cropTypeKey',
      ));
    });
  }

  QueryBuilder<FarmData, FarmData, QAfterFilterCondition> cropTypeKeyEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cropTypeKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FarmData, FarmData, QAfterFilterCondition>
      cropTypeKeyGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'cropTypeKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FarmData, FarmData, QAfterFilterCondition> cropTypeKeyLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'cropTypeKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FarmData, FarmData, QAfterFilterCondition> cropTypeKeyBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'cropTypeKey',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FarmData, FarmData, QAfterFilterCondition> cropTypeKeyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'cropTypeKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FarmData, FarmData, QAfterFilterCondition> cropTypeKeyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'cropTypeKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FarmData, FarmData, QAfterFilterCondition> cropTypeKeyContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'cropTypeKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FarmData, FarmData, QAfterFilterCondition> cropTypeKeyMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'cropTypeKey',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FarmData, FarmData, QAfterFilterCondition> cropTypeKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cropTypeKey',
        value: '',
      ));
    });
  }

  QueryBuilder<FarmData, FarmData, QAfterFilterCondition>
      cropTypeKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'cropTypeKey',
        value: '',
      ));
    });
  }

  QueryBuilder<FarmData, FarmData, QAfterFilterCondition> farmBreadthIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'farmBreadth',
      ));
    });
  }

  QueryBuilder<FarmData, FarmData, QAfterFilterCondition>
      farmBreadthIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'farmBreadth',
      ));
    });
  }

  QueryBuilder<FarmData, FarmData, QAfterFilterCondition> farmBreadthEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'farmBreadth',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FarmData, FarmData, QAfterFilterCondition>
      farmBreadthGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'farmBreadth',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FarmData, FarmData, QAfterFilterCondition> farmBreadthLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'farmBreadth',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FarmData, FarmData, QAfterFilterCondition> farmBreadthBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'farmBreadth',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FarmData, FarmData, QAfterFilterCondition> farmLengthIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'farmLength',
      ));
    });
  }

  QueryBuilder<FarmData, FarmData, QAfterFilterCondition>
      farmLengthIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'farmLength',
      ));
    });
  }

  QueryBuilder<FarmData, FarmData, QAfterFilterCondition> farmLengthEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'farmLength',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FarmData, FarmData, QAfterFilterCondition> farmLengthGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'farmLength',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FarmData, FarmData, QAfterFilterCondition> farmLengthLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'farmLength',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FarmData, FarmData, QAfterFilterCondition> farmLengthBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'farmLength',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FarmData, FarmData, QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<FarmData, FarmData, QAfterFilterCondition> idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<FarmData, FarmData, QAfterFilterCondition> idEqualTo(Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<FarmData, FarmData, QAfterFilterCondition> idGreaterThan(
    Id? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<FarmData, FarmData, QAfterFilterCondition> idLessThan(
    Id? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<FarmData, FarmData, QAfterFilterCondition> idBetween(
    Id? lower,
    Id? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FarmData, FarmData, QAfterFilterCondition> nameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'name',
      ));
    });
  }

  QueryBuilder<FarmData, FarmData, QAfterFilterCondition> nameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'name',
      ));
    });
  }

  QueryBuilder<FarmData, FarmData, QAfterFilterCondition> nameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FarmData, FarmData, QAfterFilterCondition> nameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FarmData, FarmData, QAfterFilterCondition> nameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FarmData, FarmData, QAfterFilterCondition> nameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FarmData, FarmData, QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FarmData, FarmData, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FarmData, FarmData, QAfterFilterCondition> nameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FarmData, FarmData, QAfterFilterCondition> nameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FarmData, FarmData, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<FarmData, FarmData, QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<FarmData, FarmData, QAfterFilterCondition> plantsPerRowIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'plantsPerRow',
      ));
    });
  }

  QueryBuilder<FarmData, FarmData, QAfterFilterCondition>
      plantsPerRowIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'plantsPerRow',
      ));
    });
  }

  QueryBuilder<FarmData, FarmData, QAfterFilterCondition> plantsPerRowEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'plantsPerRow',
        value: value,
      ));
    });
  }

  QueryBuilder<FarmData, FarmData, QAfterFilterCondition>
      plantsPerRowGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'plantsPerRow',
        value: value,
      ));
    });
  }

  QueryBuilder<FarmData, FarmData, QAfterFilterCondition> plantsPerRowLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'plantsPerRow',
        value: value,
      ));
    });
  }

  QueryBuilder<FarmData, FarmData, QAfterFilterCondition> plantsPerRowBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'plantsPerRow',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FarmData, FarmData, QAfterFilterCondition> rowsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'rows',
      ));
    });
  }

  QueryBuilder<FarmData, FarmData, QAfterFilterCondition> rowsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'rows',
      ));
    });
  }

  QueryBuilder<FarmData, FarmData, QAfterFilterCondition> rowsEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rows',
        value: value,
      ));
    });
  }

  QueryBuilder<FarmData, FarmData, QAfterFilterCondition> rowsGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'rows',
        value: value,
      ));
    });
  }

  QueryBuilder<FarmData, FarmData, QAfterFilterCondition> rowsLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'rows',
        value: value,
      ));
    });
  }

  QueryBuilder<FarmData, FarmData, QAfterFilterCondition> rowsBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'rows',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension FarmDataQueryObject
    on QueryBuilder<FarmData, FarmData, QFilterCondition> {}

extension FarmDataQueryLinks
    on QueryBuilder<FarmData, FarmData, QFilterCondition> {}

extension FarmDataQuerySortBy on QueryBuilder<FarmData, FarmData, QSortBy> {
  QueryBuilder<FarmData, FarmData, QAfterSortBy> sortByCropTypeKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cropTypeKey', Sort.asc);
    });
  }

  QueryBuilder<FarmData, FarmData, QAfterSortBy> sortByCropTypeKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cropTypeKey', Sort.desc);
    });
  }

  QueryBuilder<FarmData, FarmData, QAfterSortBy> sortByFarmBreadth() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'farmBreadth', Sort.asc);
    });
  }

  QueryBuilder<FarmData, FarmData, QAfterSortBy> sortByFarmBreadthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'farmBreadth', Sort.desc);
    });
  }

  QueryBuilder<FarmData, FarmData, QAfterSortBy> sortByFarmLength() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'farmLength', Sort.asc);
    });
  }

  QueryBuilder<FarmData, FarmData, QAfterSortBy> sortByFarmLengthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'farmLength', Sort.desc);
    });
  }

  QueryBuilder<FarmData, FarmData, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<FarmData, FarmData, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<FarmData, FarmData, QAfterSortBy> sortByPlantsPerRow() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'plantsPerRow', Sort.asc);
    });
  }

  QueryBuilder<FarmData, FarmData, QAfterSortBy> sortByPlantsPerRowDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'plantsPerRow', Sort.desc);
    });
  }

  QueryBuilder<FarmData, FarmData, QAfterSortBy> sortByRows() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rows', Sort.asc);
    });
  }

  QueryBuilder<FarmData, FarmData, QAfterSortBy> sortByRowsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rows', Sort.desc);
    });
  }
}

extension FarmDataQuerySortThenBy
    on QueryBuilder<FarmData, FarmData, QSortThenBy> {
  QueryBuilder<FarmData, FarmData, QAfterSortBy> thenByCropTypeKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cropTypeKey', Sort.asc);
    });
  }

  QueryBuilder<FarmData, FarmData, QAfterSortBy> thenByCropTypeKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cropTypeKey', Sort.desc);
    });
  }

  QueryBuilder<FarmData, FarmData, QAfterSortBy> thenByFarmBreadth() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'farmBreadth', Sort.asc);
    });
  }

  QueryBuilder<FarmData, FarmData, QAfterSortBy> thenByFarmBreadthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'farmBreadth', Sort.desc);
    });
  }

  QueryBuilder<FarmData, FarmData, QAfterSortBy> thenByFarmLength() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'farmLength', Sort.asc);
    });
  }

  QueryBuilder<FarmData, FarmData, QAfterSortBy> thenByFarmLengthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'farmLength', Sort.desc);
    });
  }

  QueryBuilder<FarmData, FarmData, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<FarmData, FarmData, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<FarmData, FarmData, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<FarmData, FarmData, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<FarmData, FarmData, QAfterSortBy> thenByPlantsPerRow() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'plantsPerRow', Sort.asc);
    });
  }

  QueryBuilder<FarmData, FarmData, QAfterSortBy> thenByPlantsPerRowDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'plantsPerRow', Sort.desc);
    });
  }

  QueryBuilder<FarmData, FarmData, QAfterSortBy> thenByRows() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rows', Sort.asc);
    });
  }

  QueryBuilder<FarmData, FarmData, QAfterSortBy> thenByRowsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rows', Sort.desc);
    });
  }
}

extension FarmDataQueryWhereDistinct
    on QueryBuilder<FarmData, FarmData, QDistinct> {
  QueryBuilder<FarmData, FarmData, QDistinct> distinctByCropTypeKey(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cropTypeKey', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FarmData, FarmData, QDistinct> distinctByFarmBreadth() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'farmBreadth');
    });
  }

  QueryBuilder<FarmData, FarmData, QDistinct> distinctByFarmLength() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'farmLength');
    });
  }

  QueryBuilder<FarmData, FarmData, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FarmData, FarmData, QDistinct> distinctByPlantsPerRow() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'plantsPerRow');
    });
  }

  QueryBuilder<FarmData, FarmData, QDistinct> distinctByRows() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'rows');
    });
  }
}

extension FarmDataQueryProperty
    on QueryBuilder<FarmData, FarmData, QQueryProperty> {
  QueryBuilder<FarmData, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<FarmData, String?, QQueryOperations> cropTypeKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cropTypeKey');
    });
  }

  QueryBuilder<FarmData, double?, QQueryOperations> farmBreadthProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'farmBreadth');
    });
  }

  QueryBuilder<FarmData, double?, QQueryOperations> farmLengthProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'farmLength');
    });
  }

  QueryBuilder<FarmData, String?, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<FarmData, int?, QQueryOperations> plantsPerRowProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'plantsPerRow');
    });
  }

  QueryBuilder<FarmData, int?, QQueryOperations> rowsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rows');
    });
  }
}
